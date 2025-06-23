import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static final _db = FirebaseDatabase.instance.ref();

  // Gerar código único para o grupo
  static String _generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Criar um novo grupo
  static Future<Map<String, dynamic>> createGroup({
    required String name,
    required String creatorId,
  }) async {
    print('Criando grupo: $name por $creatorId');
    
    final groupRef = _db.child('groups').push();
    final groupId = groupRef.key!;
    final groupCode = _generateGroupCode();
    
    print('ID do grupo: $groupId');
    print('Código do grupo: $groupCode');
    
    final groupData = {
      'id': groupId,
      'name': name,
      'creatorId': creatorId,
      'groupCode': groupCode,
      'createdAt': ServerValue.timestamp,
      'updatedAt': ServerValue.timestamp,
      'members': {
        creatorId: {
          'role': 'creator',
          'joinedAt': ServerValue.timestamp,
        }
      },
      'joinRequests': {},
    };

    print('Dados do grupo: $groupData');
    await groupRef.set(groupData);
    print('Grupo criado com sucesso');
    
    return {
      'groupId': groupId,
      'groupCode': groupCode,
      'groupData': groupData,
    };
  }

  // Buscar grupo por ID
  static Future<Map<String, dynamic>?> getGroupById(String groupId) async {
    try {
      print('Buscando grupo por ID: $groupId');
      final snapshot = await _db.child('groups/$groupId').get();
      
      print('Snapshot existe: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final groupData = Map<String, dynamic>.from(snapshot.value as Map);
        groupData['groupId'] = groupId;
        print('Grupo encontrado: ${groupData['name']}');
        return groupData;
      }
      
      print('Grupo não encontrado');
      return null;
    } catch (e) {
      print('Erro ao buscar grupo por ID: $e');
      return null;
    }
  }

  // Buscar grupos criados pelo usuário
  static Future<List<Map<String, dynamic>>> getGroupsCreatedByUser(String userId) async {
    try {
      print('Buscando grupos criados por: $userId');
      final snapshot = await _db.child('groups')
          .orderByChild('creatorId')
          .equalTo(userId)
          .get();
      
      print('Snapshot existe: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> groups = snapshot.value as Map;
        print('Grupos encontrados: ${groups.length}');
        
        final List<Map<String, dynamic>> result = [];
        
        groups.forEach((key, group) {
          print('Processando grupo: $key');
          final groupData = Map<String, dynamic>.from(group);
          groupData['groupId'] = key;
          result.add(groupData);
        });
        
        print('Resultado final: ${result.length} grupos');
        return result;
      }
      print('Nenhum grupo encontrado');
      return [];
    } catch (e) {
      print('Erro ao buscar grupos criados: $e');
      return [];
    }
  }

  // Buscar grupos que o usuário participa (não criou)
  static Future<List<Map<String, dynamic>>> getGroupsUserParticipates(String userId) async {
    try {
      final snapshot = await _db.child('groups').get();
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> groups = snapshot.value as Map;
        final List<Map<String, dynamic>> userGroups = [];
        
        groups.forEach((key, group) {
          final groupData = Map<String, dynamic>.from(group);
          final members = groupData['members'] as Map<dynamic, dynamic>?;
          
          if (members != null && members.containsKey(userId) && groupData['creatorId'] != userId) {
            groupData['groupId'] = key;
            userGroups.add(groupData);
          }
        });
        
        return userGroups;
      }
      return [];
    } catch (e) {
      print('Erro ao buscar grupos do usuário: $e');
      return [];
    }
  }

  // Buscar solicitações pendentes para grupos criados pelo usuário
  static Future<List<Map<String, dynamic>>> getPendingJoinRequests(String userId) async {
    try {
      print('Buscando solicitações pendentes para usuário: $userId');
      final snapshot = await _db.child('groups').get();
      
      print('Snapshot existe: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> groups = snapshot.value as Map;
        print('Total de grupos encontrados: ${groups.length}');
        final List<Map<String, dynamic>> requests = [];
        
        groups.forEach((key, group) {
          final groupData = Map<String, dynamic>.from(group);
          print('Verificando grupo: ${groupData['name']} (criador: ${groupData['creatorId']})');
          
          // Verificar se o usuário é o criador do grupo
          if (groupData['creatorId'] == userId) {
            print('Usuário é criador do grupo: ${groupData['name']}');
            final joinRequests = groupData['joinRequests'] as Map<dynamic, dynamic>?;
            
            print('JoinRequests encontrados: ${joinRequests?.length ?? 0}');
            
            if (joinRequests != null && joinRequests.isNotEmpty) {
              joinRequests.forEach((requestKey, request) {
                print('Processando solicitação: $requestKey');
                final requestData = Map<String, dynamic>.from(request);
                requestData['groupId'] = key;
                requestData['groupName'] = groupData['name'];
                requestData['requestId'] = requestKey;
                requests.add(requestData);
                print('Solicitação adicionada: ${requestData['userName']} para ${requestData['groupName']}');
              });
            } else {
              print('Nenhuma solicitação pendente no grupo: ${groupData['name']}');
            }
          } else {
            print('Usuário não é criador do grupo: ${groupData['name']}');
          }
        });
        
        print('Total de solicitações encontradas: ${requests.length}');
        return requests;
      }
      print('Nenhum grupo encontrado');
      return [];
    } catch (e) {
      print('Erro ao buscar solicitações: $e');
      return [];
    }
  }

  // Solicitar entrada no grupo usando código
  static Future<bool> requestJoinGroup({
    required String groupCode,
    required String userId,
  }) async {
    try {
      print('Solicitando entrada no grupo com código: $groupCode');
      print('Usuário ID: $userId');
      
      // Buscar grupo pelo código
      final snapshot = await _db.child('groups')
          .orderByChild('groupCode')
          .equalTo(groupCode)
          .get();
      
      print('Snapshot existe: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> groups = snapshot.value as Map;
        final groupKey = groups.keys.first;
        final groupData = Map<String, dynamic>.from(groups[groupKey]);
        
        print('Grupo encontrado: ${groupData['name']} (ID: $groupKey)');
        print('Criador do grupo: ${groupData['creatorId']}');
        
        // Verificar se o usuário já é membro
        final members = groupData['members'] as Map<dynamic, dynamic>?;
        if (members != null && members.containsKey(userId)) {
          print('Usuário já é membro do grupo');
          return false; // Já é membro
        }
        
        // Verificar se já existe uma solicitação pendente
        final joinRequests = groupData['joinRequests'] as Map<dynamic, dynamic>?;
        if (joinRequests != null && joinRequests.containsKey(userId)) {
          print('Já existe solicitação pendente para este usuário');
          return false; // Já existe solicitação pendente
        }
        
        print('Criando solicitação de entrada...');
        
        // Criar solicitação de entrada
        await _db.child('groups/$groupKey/joinRequests/$userId').set({
          'userId': userId,
          'requestedAt': ServerValue.timestamp,
          'status': 'pending',
        });
        
        print('Solicitação criada com sucesso!');
        return true;
      }
      print('Código de grupo não encontrado');
      return false; // Código não encontrado
    } catch (e) {
      print('Erro ao solicitar entrada no grupo: $e');
      return false;
    }
  }

  // Aceitar solicitação de entrada (apenas criador)
  static Future<void> acceptJoinRequest({
    required String groupId,
    required String userId,
    required String creatorId,
  }) async {
    try {
      // Verificar se o usuário é o criador
      final snapshot = await _db.child('groups/$groupId/creatorId').get();
      if (snapshot.exists && snapshot.value == creatorId) {
        // Adicionar usuário aos membros
        await _db.child('groups/$groupId/members/$userId').set({
          'role': 'member',
          'joinedAt': ServerValue.timestamp,
        });
        
        // Remover solicitação
        await _db.child('groups/$groupId/joinRequests/$userId').remove();
      }
    } catch (e) {
      print('Erro ao aceitar solicitação: $e');
      rethrow;
    }
  }

  // Recusar solicitação de entrada (apenas criador)
  static Future<void> declineJoinRequest({
    required String groupId,
    required String userId,
    required String creatorId,
  }) async {
    try {
      // Verificar se o usuário é o criador
      final snapshot = await _db.child('groups/$groupId/creatorId').get();
      if (snapshot.exists && snapshot.value == creatorId) {
        // Remover solicitação
        await _db.child('groups/$groupId/joinRequests/$userId').remove();
      }
    } catch (e) {
      print('Erro ao recusar solicitação: $e');
      rethrow;
    }
  }

  // Sair do grupo
  static Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _db.child('groups/$groupId/members/$userId').remove();
      await _db.child('schedules/$groupId/$userId').remove();
    } catch (e) {
      print('Erro ao sair do grupo: $e');
      rethrow;
    }
  }

  // Remover usuário do grupo (apenas criador pode fazer)
  static Future<void> removeUserFromGroup({
    required String groupId,
    required String userId,
    required String creatorId,
  }) async {
    try {
      final snapshot = await _db.child('groups/$groupId/creatorId').get();
      if (snapshot.exists && snapshot.value == creatorId) {
        await _db.child('groups/$groupId/members/$userId').remove();
        await _db.child('schedules/$groupId/$userId').remove();
      }
    } catch (e) {
      print('Erro ao remover usuário do grupo: $e');
      rethrow;
    }
  }

  // Buscar membros do grupo (apenas criador pode ver)
  static Future<List<Map<String, dynamic>>> getGroupMembers({
    required String groupId,
    required String requesterId,
  }) async {
    try {
      final snapshot = await _db.child('groups/$groupId').get();
      
      if (snapshot.exists) {
        final groupData = Map<String, dynamic>.from(snapshot.value as Map);
        
        // Verificar se o usuário é o criador
        if (groupData['creatorId'] == requesterId) {
          final members = groupData['members'] as Map<dynamic, dynamic>?;
          if (members != null) {
            final List<Map<String, dynamic>> result = [];
            
            members.forEach((userId, memberData) {
              final member = Map<String, dynamic>.from(memberData);
              member['userId'] = userId;
              result.add(member);
            });
            
            return result;
          }
        }
      }
      return [];
    } catch (e) {
      print('Erro ao buscar membros do grupo: $e');
      return [];
    }
  }

  // Deletar grupo (apenas criador pode fazer)
  static Future<void> deleteGroup({
    required String groupId,
    required String creatorId,
  }) async {
    try {
      final snapshot = await _db.child('groups/$groupId/creatorId').get();
      if (snapshot.exists && snapshot.value == creatorId) {
        await _db.child('groups/$groupId').remove();
      }
    } catch (e) {
      print('Erro ao deletar grupo: $e');
      rethrow;
    }
  }

  // Buscar usuários por nome para convite
  static Future<List<Map<String, dynamic>>> searchUsersByName(String searchTerm) async {
    try {
      final snapshot = await _db.child('users').get();
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> users = snapshot.value as Map;
        final List<Map<String, dynamic>> results = [];
        
        users.forEach((key, user) {
          final userData = Map<String, dynamic>.from(user);
          final userName = userData['nome']?.toString().toLowerCase() ?? '';
          
          if (userName.contains(searchTerm.toLowerCase())) {
            userData['uid'] = key;
            results.add(userData);
          }
        });
        
        return results;
      }
      return [];
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return [];
    }
  }

  // Buscar endereço pelo CEP
  static Future<Map<String, String>?> fetchAddressFromCep(String cep) async {
    try {
      final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
      final url = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) return null;
        
        return {
          'rua': data['logradouro'] ?? '',
          'bairro': data['bairro'] ?? '',
          'cidade': data['localidade'] ?? '',
          'estado': data['uf'] ?? '',
        };
      }
      return null;
    } catch (e) {
      print('Erro ao buscar CEP: $e');
      return null;
    }
  }
} 
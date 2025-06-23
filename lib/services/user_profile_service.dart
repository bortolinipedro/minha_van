import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserProfileService {
  static final _db = FirebaseDatabase.instance.ref();

  static Future<void> createOrUpdateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _db.child('users/$uid').update(data);
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _db.child('users/$uid').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  static Future<void> deleteUserProfile(String uid) async {
    await _db.child('users/$uid').remove();
  }

  static Future<Map<String, String>?> fetchAddressFromCep(String cep) async {
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
  }

  // Buscar múltiplos perfis de usuários de forma performática
  static Future<Map<String, Map<String, dynamic>>> getMultipleUserProfiles(List<String> userIds) async {
    try {
      final Map<String, Map<String, dynamic>> profiles = {};
      
      // Buscar todos os perfis em uma única operação
      final snapshot = await _db.child('users').get();
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> allUsers = snapshot.value as Map;
        
        for (final userId in userIds) {
          if (allUsers.containsKey(userId)) {
            final userData = Map<String, dynamic>.from(allUsers[userId]);
            profiles[userId] = userData;
          }
        }
      }
      
      return profiles;
    } catch (e) {
      print('Erro ao buscar múltiplos perfis: $e');
      return {};
    }
  }

  // Buscar nome do usuário por ID
  static Future<String> getUserName(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      return profile?['nome'] ?? 'Usuário';
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      return 'Usuário';
    }
  }
} 
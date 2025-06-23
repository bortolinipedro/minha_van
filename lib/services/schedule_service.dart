import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleService {
  static final _db = FirebaseDatabase.instance.ref();

  // Criar ou atualizar schedule semanal para um usuário em um grupo
  static Future<bool> createWeeklySchedule({
    required String groupId,
    required String userId,
    required String groupName,
    required int dayOfWeek,
    required Map<String, dynamic> going,
    required Map<String, dynamic> returning,
  }) async {
    try {
      print('Criando schedule para usuário $userId no grupo $groupId para dia $dayOfWeek');
      print('Nome do grupo: $groupName');
      print('Going: $going');
      print('Returning: $returning');
      
      final scheduleId = 'schedule_${_getDayName(dayOfWeek)}';
      print('Schedule ID: $scheduleId');
      
      final scheduleData = {
        'userId': userId,
        'groupId': groupId,
        'groupName': groupName,
        'dayOfWeek': dayOfWeek,
        'going': going,
        'returning': returning,
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      };

      print('Dados do schedule: $scheduleData');
      print('Caminho no Firebase: schedules/$groupId/$userId/$scheduleId');

      await _db.child('schedules/$groupId/$userId/$scheduleId').set(scheduleData);
      
      print('Schedule criado com sucesso');
      
      // Verificar se foi salvo corretamente
      final verificationSnapshot = await _db.child('schedules/$groupId/$userId/$scheduleId').get();
      if (verificationSnapshot.exists) {
        print('Verificação: Schedule salvo corretamente');
        final savedData = verificationSnapshot.value;
        print('Dados salvos: $savedData');
      } else {
        print('ERRO: Schedule não foi salvo corretamente');
      }
      
      return true;
    } catch (e) {
      print('Erro ao criar schedule: $e');
      return false;
    }
  }

  // Buscar schedule semanal de um usuário em um grupo
  static Future<Map<String, dynamic>?> getWeeklySchedule({
    required String groupId,
    required String userId,
    required int dayOfWeek,
  }) async {
    try {
      final scheduleId = 'schedule_${_getDayName(dayOfWeek)}';
      final snapshot = await _db.child('schedules/$groupId/$userId/$scheduleId').get();
      
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar schedule: $e');
      return null;
    }
  }

  // Buscar todos os schedules de um usuário em um grupo
  static Future<List<Map<String, dynamic>>> getUserSchedulesInGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      print('Buscando schedules para usuário $userId no grupo $groupId');
      final snapshot = await _db.child('schedules/$groupId/$userId').get();
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> schedules = snapshot.value as Map;
        final List<Map<String, dynamic>> result = [];
        
        print('Schedules encontrados: ${schedules.length}');
        print('Dados brutos: $schedules');
        
        schedules.forEach((key, schedule) {
          print('Processando schedule: $key');
          print('Dados do schedule: $schedule');
          
          // Converter para Map<String, dynamic> de forma segura
          Map<String, dynamic> scheduleData;
          if (schedule is Map) {
            scheduleData = Map<String, dynamic>.from(schedule);
          } else {
            print('ERRO: Schedule não é um Map válido: $schedule');
            return;
          }
          
          scheduleData['scheduleId'] = key.toString();
          result.add(scheduleData);
          print('Schedule adicionado: ${scheduleData['dayOfWeek']} - ${scheduleData['userName']}');
        });
        
        print('Total de schedules retornados: ${result.length}');
        print('Schedules finais: $result');
        return result;
      }
      print('Nenhum schedule encontrado');
      return [];
    } catch (e) {
      print('Erro ao buscar schedules do usuário: $e');
      return [];
    }
  }

  // Buscar todos os schedules de um grupo para um dia específico
  static Future<List<Map<String, dynamic>>> getGroupSchedulesForDay({
    required String groupId,
    required int dayOfWeek,
  }) async {
    try {
      print('Buscando schedules para grupo $groupId, dia $dayOfWeek');
      final snapshot = await _db.child('schedules/$groupId').get();
      
      print('Snapshot existe: ${snapshot.exists}');
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> users = snapshot.value as Map;
        final List<Map<String, dynamic>> result = [];
        
        print('Usuários encontrados no grupo: ${users.length}');
        print('Chaves dos usuários: ${users.keys.toList()}');
        
        users.forEach((userId, userSchedules) {
          print('Processando usuário: $userId');
          print('Schedules do usuário: $userSchedules');
          
          final userSchedulesMap = Map<String, dynamic>.from(userSchedules);
          final scheduleId = 'schedule_${_getDayName(dayOfWeek)}';
          
          print('Procurando schedule ID: $scheduleId');
          print('Schedules disponíveis: ${userSchedulesMap.keys.toList()}');
          
          if (userSchedulesMap.containsKey(scheduleId)) {
            print('Schedule encontrado para $scheduleId');
            final scheduleData = Map<String, dynamic>.from(userSchedulesMap[scheduleId]);
            scheduleData['scheduleId'] = scheduleId;
            scheduleData['userId'] = userId;
            result.add(scheduleData);
            print('Schedule adicionado: ${scheduleData['userName'] ?? 'Sem nome'} - ${scheduleData['dayOfWeek']}');
          } else {
            print('Schedule não encontrado para $scheduleId');
          }
        });
        
        print('Total de schedules retornados: ${result.length}');
        return result;
      }
      print('Nenhum usuário encontrado no grupo');
      return [];
    } catch (e) {
      print('Erro ao buscar schedules do grupo: $e');
      return [];
    }
  }

  // Confirmar schedule para um dia específico
  static Future<bool> confirmDailySchedule({
    required String groupId,
    required String userId,
    required String date,
    required Map<String, dynamic> going,
    required Map<String, dynamic> returning,
  }) async {
    try {
      print('Confirmando schedule para $userId no grupo $groupId para $date');
      
      final dailyScheduleData = {
        'going': {
          ...going,
          'confirmedAt': ServerValue.timestamp,
        },
        'returning': {
          ...returning,
          'confirmedAt': ServerValue.timestamp,
        },
      };

      await _db.child('dailySchedules/$date/$groupId/$userId').set(dailyScheduleData);
      
      print('Schedule diário confirmado com sucesso');
      return true;
    } catch (e) {
      print('Erro ao confirmar schedule diário: $e');
      return false;
    }
  }

  // Buscar schedule confirmado para um dia específico
  static Future<Map<String, dynamic>?> getDailySchedule({
    required String groupId,
    required String userId,
    required String date,
  }) async {
    try {
      final snapshot = await _db.child('dailySchedules/$date/$groupId/$userId').get();
      
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar schedule diário: $e');
      return null;
    }
  }

  // Buscar todos os schedules confirmados de um grupo para um dia específico
  static Future<List<Map<String, dynamic>>> getGroupDailySchedules({
    required String groupId,
    required String date,
  }) async {
    try {
      final snapshot = await _db.child('dailySchedules/$date/$groupId').get();
      
      if (snapshot.exists) {
        final Map<dynamic, dynamic> users = snapshot.value as Map;
        final List<Map<String, dynamic>> result = [];
        
        users.forEach((userId, schedule) {
          final scheduleData = Map<String, dynamic>.from(schedule);
          scheduleData['userId'] = userId;
          result.add(scheduleData);
        });
        
        return result;
      }
      return [];
    } catch (e) {
      print('Erro ao buscar schedules diários do grupo: $e');
      return [];
    }
  }

  // Deletar schedule semanal
  static Future<bool> deleteWeeklySchedule({
    required String groupId,
    required String userId,
    required int dayOfWeek,
  }) async {
    try {
      final scheduleId = 'schedule_${_getDayName(dayOfWeek)}';
      await _db.child('schedules/$groupId/$userId/$scheduleId').remove();
      return true;
    } catch (e) {
      print('Erro ao deletar schedule: $e');
      return false;
    }
  }

  // Deletar schedule diário
  static Future<bool> deleteDailySchedule({
    required String groupId,
    required String userId,
    required String date,
  }) async {
    try {
      await _db.child('dailySchedules/$date/$groupId/$userId').remove();
      return true;
    } catch (e) {
      print('Erro ao deletar schedule diário: $e');
      return false;
    }
  }

  // Gerar schedule diário baseado no schedule semanal
  static Future<bool> generateDailyScheduleFromWeekly({
    required String groupId,
    required String date,
  }) async {
    try {
      final dayOfWeek = _getDayOfWeekFromDate(date);
      final weeklySchedules = await getGroupSchedulesForDay(
        groupId: groupId,
        dayOfWeek: dayOfWeek,
      );

      for (final schedule in weeklySchedules) {
        final userId = schedule['userId'];
        
        await confirmDailySchedule(
          groupId: groupId,
          userId: userId,
          date: date,
          going: schedule['going'],
          returning: schedule['returning'],
        );
      }

      return true;
    } catch (e) {
      print('Erro ao gerar schedule diário: $e');
      return false;
    }
  }

  // Utilitários
  static String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  static int _getDayOfWeekFromDate(String date) {
    final dateTime = DateTime.parse(date);
    return dateTime.weekday;
  }

  // Formatar data para o formato usado no Firebase
  static String formatDateForFirebase(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Verificar se um usuário tem schedule para hoje
  static Future<Map<String, dynamic>?> getTodaySchedule({
    required String groupId,
    required String userId,
  }) async {
    try {
      final today = formatDateForFirebase(DateTime.now());
      return await getDailySchedule(
        groupId: groupId,
        userId: userId,
        date: today,
      );
    } catch (e) {
      print('Erro ao buscar schedule de hoje: $e');
      return null;
    }
  }

  // Buscar todos os schedules de hoje para um grupo
  static Future<List<Map<String, dynamic>>> getTodayGroupSchedules({
    required String groupId,
  }) async {
    try {
      final today = formatDateForFirebase(DateTime.now());
      return await getGroupDailySchedules(
        groupId: groupId,
        date: today,
      );
    } catch (e) {
      print('Erro ao buscar schedules de hoje do grupo: $e');
      return [];
    }
  }
} 
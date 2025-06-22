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
} 
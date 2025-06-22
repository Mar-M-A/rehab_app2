// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rehab_app2/models/set_model.dart';
import '../models/exercise_model.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:5000';
  ///mirar la ip en el comando ipconfig getifaddr en0
  static String baseUrl = 'http://192.168.1.43:5000';

  static setUrl(String url) {
    baseUrl = 'http://$url:5000';
    //print('New URL: $baseUrl');
  }


  static Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(
          Uri.parse('$baseUrl/dbGet?table=exercise'),
          headers: {'Content-Type': 'application/json'},
      );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Exercise.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<List<SetInfo>> fetchSets(int sessionId) async {
    final response = await http.get(
          Uri.parse('$baseUrl/sets?session_id=$sessionId'),
          headers: {'Content-Type': 'application/json'},
      );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => SetInfo.fromJson(item)).toList();
    } else {
      return [];
      // throw Exception('Failed to load sets');
    }
  }

  static Future<int?> startExerciseSet(
      int sessionId, int exerciseId, int reps, double weight) async {
    Map data = {
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'reps': reps,
      'weight': weight
    };
    final response = await http.post(
      Uri.parse('$baseUrl/addExercise'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['id'];
    } else {
      print('Failed to start exercise set: ${response.body}');
      return -1;
    }
  }

  static Future<int?> createNewSession(
      String userId) async {
    Map data = {
      'user_id': userId,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/createSession'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['id'];
    } else {
      print('Failed to create session: ${response.body}');
      return 1;
    }
  }

  static Future<bool> finishSession(
      int sessionId) async {
    Map data = {
      'session_id': sessionId,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/finishSession'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 500)
    {
      print("Error finishing session");
    }    
    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getUserSessions(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/userSessions?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
      // throw Exception('Failed to load sessions');
    }
  }

  static Future<bool> setMetrics(
      int setId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/setMetrics'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'set_id': setId
      }),
    );
    if (response.statusCode == 500)
    {
      print("Possible error in set metrics");
    }    
    return response.statusCode == 201;
  }

  static Future<bool> setExercise(
      int userId, int setId, int exerciseId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/setCurrentExercise'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'set_id': setId,
        'exercise_id': exerciseId,
      }),
    );
    if (response.statusCode != 200)
    {
      print("Possible error in set Exercise");
    }    
    return response.statusCode == 200;
  }
}

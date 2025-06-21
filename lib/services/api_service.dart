import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/metrics_model.dart';
import '../models/exercise_model.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:5000';
  ///mirar la ip en el comando ipconfig getifaddr en0
  static const String baseUrl = 'http://192.168.1.43:5000';


  

  // static Future<List<Metrics>> fetchMetrics(String exerciseName) async {
  //   final response = await http
  //       .get(Uri.parse('$baseUrl/getExercise?exerciseName=$exerciseName'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     return jsonData.map((item) => Metrics.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load metrics');
  //   }
  // }

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

  static Future<List<Metrics>> getSessionExercises() async {
    final response = await http
        .get(Uri.parse('$baseUrl/sessionExercises?exerciseName'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Metrics.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load metrics');
    }
  }

  static Future<List<Metrics>> fetchSessionExercisesummary(
      int sessionExerciseId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/sessionExerciseMetrics?sessionExerciseId=$sessionExerciseId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Metrics.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load session exercise summary metrics.');
    }
  }

  static Future<int?> startExerciseSet(
      int sessionId, int exerciseId) async {
    Map data = {
      'session_id': sessionId,
      'exercise_id': exerciseId,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/startExerciseSession'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['sessionExerciseId'];
    } else {
      print('Failed to start exercise set: ${response.body}');
      return 1;
    }
  }

  static Future<int?> createNewSession(
      String user_id) async {
    Map data = {
      'user_id': user_id,
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

  //! en principio no se usa (a no ser que hagamos un login)
  // static Future<bool> createUser(Map<String, dynamic> data) async {
  //   print("createUser , $data");
  //   final response = await http.post(Uri.parse('$baseUrl/createUser'),
  //       headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
  //   print("response $response");
  //   return response.statusCode == 201;
  // }

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

  //TODO call when finished exercise
  static Future<bool> setMetrics(
      int setId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/setMetrics'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'set_id': setId
      }),
    );
    return response.statusCode == 200;
  }
}

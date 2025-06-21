import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/metrics_model.dart';
import '../models/exercise_model.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:5000';
  ///mirar la ip en el comando ipconfig getifaddr en0
  static const String baseUrl = 'http://127.0.0.1:5000'; //'http://192.168.1.127:5000';


  

  static Future<List<Metrics>> fetchMetrics(String exerciseName) async {
    final response = await http
        .get(Uri.parse('$baseUrl/getExercise?exerciseName=$exerciseName'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Metrics.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load metrics');
    }
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

  static Future<int?> startExerciseSession(
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
      print('Failed to start exercise session: ${response.body}');
      return 1;
    }
  }

  static Future<bool> createUser(Map<String, dynamic> data) async {
    print("createUser , $data");
    final response = await http.post(Uri.parse('$baseUrl/createUser'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    print("response $response");
    return response.statusCode == 201;
  }

  static Future<List<dynamic>> getUserSessions(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/userSessions?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  static Future<bool> setMetrics(
      int sessionExerciseId, double meanHr, double meanBr) async {
    final response = await http.post(
      Uri.parse('$baseUrl/setMetrics'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session:ecercise': sessionExerciseId,
        'mean_hr': meanHr,
        'mean_br': meanBr,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> sendPox(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendPox'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }
}

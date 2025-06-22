// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rehab_app2/models/point_model.dart';
import 'package:rehab_app2/models/set_model.dart';
import '../models/exercise_model.dart';

class ApiService {
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

  static Future<List<List<PointInfo>>> fetchSetSummary(int setId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getSetSummary?set_id=$setId'),
      headers: {'Content-Type': 'application/json'},
    );

    List<PointInfo> completenessPoints = [];
    List<PointInfo> instabilityPoints = [];
    List<PointInfo> breathRatePoints = [];
    List<PointInfo> heartRatePoints = [];

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract kinect data
      if (jsonData.containsKey('kinect')) {
        final List<dynamic> kinectList = jsonData['kinect'];
        for (var item in kinectList) {
          double? completeness = (item['completeness'] as num?)?.toDouble();
          double? instability = (item['instability'] as num?)?.toDouble();
          double? ts = (item['ts'] as num?)?.toDouble();

          if (completeness != null && ts != null) {
            completenessPoints.add(PointInfo(x: ts, y: completeness));
          }
          if (instability != null && ts != null) {
            instabilityPoints.add(PointInfo(x: ts, y: instability));
          }
        }
      }

      // Extract pox data
      if (jsonData.containsKey('pox')) {
        final List<dynamic> poxList = jsonData['pox'];
        for (var item in poxList) {
          double? breathRate = (item['breath_rate'] as num?)?.toDouble();
          double? heartRate = (item['heart_rate'] as num?)?.toDouble();
          double? ts = (item['ts'] as num?)?.toDouble();

          if (breathRate != null && ts != null) {
            breathRatePoints.add(PointInfo(x: ts, y: breathRate));
          }
          if (heartRate != null && ts != null) {
            heartRatePoints.add(PointInfo(x: ts, y: heartRate));
          }
        }
      }
    }

    return [completenessPoints, instabilityPoints, heartRatePoints, breathRatePoints];
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

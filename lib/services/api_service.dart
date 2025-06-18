import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/metrics_model.dart';

class ApiService
{
    static const String baseUrl = 'https://api';

    static Future<List<Metrics>> fetchMetrics(String exerciseName) async
    {
        final response = await http.get(Uri.parse('$baseUrl/getExercise?exerciseName=$exerciseName'));

        if (response.statusCode == 200)
        {
            final List<dynamic> jsonData = json.decode(response.body);
            return jsonData.map((item) => Metrics.fromJson(item)).toList();
        } else {
            throw Exception('Failed to load metrics');
        }
    }

    static Future<List<Metrics>> fetchSessionExercisesummary(int sessionExerciseId) async
    {
        final response = await http.get(Uri.parse('$baseUrl/sessionExerciseMetrics?sessionExerciseId=$sessionExerciseId'));

        if (response.statusCode == 200)
        {
            final List<dynamic> jsonData = json.decode(response.body);
            return jsonData.map((item) => Metrics.fromJson(item)).toList();
        }
        else
        {
            throw Exception ('Failed to load session exercise summary metrics.');
        }
    }

    static Future<int?> startExerciseSession(int sessionId, int exerciseId) async
    {
        final response = await http.post(
            Uri.parse('$baseUrl/startExerciseSession'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
                {
                    'session_id': sessionId,
                    'exercise:_id' exerciseId,
                }
            ),
        );

        if (response.statusCode == 201)
        {
            final Map<String, dynamic> data = json.decode(response.body);
            return data['sessionExerciseId'];
        }
        else
        {
            print('Failed to start exercise session: ${response.body}');
            return null;
        }
    }

    static Future<bool> createUser(Map<String, dynamic> data) async
    {
        final response await http.post(
            Uri.parse('$baseUrl/createUser'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data)
        );
        return response.statusCode == 200;
    }

    static Future<List<dynamic>> getUserSessions(String userId) async
    {
        final response = await http.get(
            Uri.parse('$baseUrl/userSessions?user=$userId'),
        );
        if (response.statusCode == 200)
        {
            return jsonDecode(response.body);
        }
        else
        {
            throw Exception('Failed to load sessions');
        }
    }

    static Future<bool> setMetrics(int sessionExerciseId, double meanHr, double meanBr) async
    {
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

    static Future<bool> sendPox(Map<String, dynamic> data) async
    {
        final response = await http.post(
            Uri.parse('$baseUrl/sendPox'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
        );
        return response.statusCode == 200;
    }
}
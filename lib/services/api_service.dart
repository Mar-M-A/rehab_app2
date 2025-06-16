import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService
{
    static const String baseUrl = 'https://api';

    static Future<List<Metrics>> fetchMetrics() async
    {
        final response = await http.get(Uri.parse('https://yourapi.com/metrics?exercise=$exerciseName'));

        if (response.statusCode == 200)
        {
            final List<dynamic> jsonData = json.decode(response.body);
            return jsonData.map((item) => Metrics.fromJson(item)).toList();
        } else {
            throw Exception('Failed to load metrics');
        }
    }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost/flutter_api/";

  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, String> data) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

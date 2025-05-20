import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";
  static final _logger = Logger();

  static Future<Map<String, dynamic>> getAll(String path) async {
  final uri = Uri.parse("$_baseUrl/$path"); // path = "list"
  _logger.i("GET ALL : $uri");

  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));
    _logger.i("Response : ${response.statusCode}");
    _logger.t("Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return jsonMap;
    } else {
      _logger.e("Error : ${response.statusCode}");
      throw Exception("Server Error : ${response.statusCode}");
    }
  } on TimeoutException {
      _logger.e("Request Timed Out to $uri");
      throw Exception("Request Timed Out");
  } catch (e) {
      _logger.e("Error fetching data from $uri : $e");
      throw Exception("Error fetching data : $e");
    }
  }
}
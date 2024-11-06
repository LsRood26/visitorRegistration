import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  String baseUrl = 'http://10.0.2.2:3000';
  String? _token;

  HttpClient._internal();

  factory HttpClient() {
    return _instance;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  String? getToken() {
    return _token;
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<dynamic> get(String route) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$route'),
          headers: await _getHeaders());
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> post(String route, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$route'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> put(String route, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$route'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> patch(String route, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$route'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> delete(String route) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$route'),
          headers: await _getHeaders());
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body); // Respuesta exitosa
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Método para manejar errores
  dynamic _handleError(dynamic error) {
    print('Ocurrió un error: $error');
    return 'Ocurrió un error desconocido';
  }
}

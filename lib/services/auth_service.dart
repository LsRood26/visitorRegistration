import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/providers/provider_login.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<void> login(String dni, String password, BuildContext context) async {
    final provider = Provider.of<ProviderLogin>(context, listen: false);
    final url = Uri.parse('http://10.0.2.2:3000/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'dni': dni,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('respuesta: ${response.body}');
        final responseData = json.decode(response.body);
        print('Token: ${responseData["access_token"]}');
        final token = responseData['access_token'];
        //await storage.write(key: 'acces_token', value: token);
        await provider.saveToken(token);
        provider.dni = responseData["dni"];
        provider.name = responseData["name"];
        provider.lastname = responseData["lastname"];
        provider.roleId = responseData["role"]["id"];
        provider.role = responseData["role"]["name"];
        provider.cleanInputs();
        Navigator.pushReplacementNamed(context, '/residenthome');
      } else {
        print('Error: ${response.statusCode}');
        print('Mensaje: ${response.body}');
      }
    } catch (error) {
      print('Error de conexion: $error');
    }
  }

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'access_token');
    Navigator.pushReplacementNamed(context, '/');
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/models/role.dart';
import 'package:visitorregistration/models/users.dart';
import 'package:visitorregistration/providers/provider_login.dart';
import 'package:visitorregistration/services/http_client.dart';

class AuthService {
  HttpClient client = HttpClient();

  Future<void> login(String dni, String password, BuildContext context) async {
    final provider = Provider.of<ProviderLogin>(context, listen: false);

    try {
      final body = {
        'dni': dni,
        'password': password,
      };
      final response = await client.post('/auth/login', body);
      final token = response['access_token'];
      client.setToken(token);
      User user = User.fromMap(response);
      int roleId = response["role"]["id"];
      user = User(
          dni: dni,
          name: user.name,
          lastName: user.lastName,
          role: Role(id: roleId, name: user.role.name),
          accessToken: user.accessToken);

      provider.cleanInputs();
      Future.delayed(Duration(seconds: 1));
      Navigator.pushNamed(context, '/residenthome', arguments: user);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Credenciales Incorrectas",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    client.setToken('');
    Navigator.pushReplacementNamed(context, '/');
  }
}

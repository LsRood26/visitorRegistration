import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

class ProviderLogin with ChangeNotifier {
  TextEditingController _dniController = TextEditingController(text: '');
  TextEditingController get dniController => _dniController;
  set dniController(TextEditingController value) {
    _dniController = value;
    notifyListeners();
  }

  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController get passwordController => _passwordController;
  set passwordController(TextEditingController value) {
    _passwordController = value;
    notifyListeners();
  }

  cleanInputs() {
    _dniController.text = "";
    _passwordController.text = "";
  }

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'access_token');
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
    _token = token;
    notifyListeners();
  }

  String? name;
  String? lastname;
  String? dni;
  int? roleId;
  String? role;

  String? get getdni => dni;
  String? get getname => name;
  String? get getlastname => lastname;
  int? get getroleId => roleId;
  String? get getrole => role;
}

import 'package:flutter/material.dart';

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

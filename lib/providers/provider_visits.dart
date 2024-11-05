import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:http/http.dart' as http;
import 'package:visitorregistration/providers/provider_login.dart';

class ProviderRequests with ChangeNotifier {
  List<CustomRequests> _requests = [];
  bool _isLoading = false;
  String? _errorMessage;
  CustomRequests? request;

  Map<String, dynamic>? _visitorInfo;

  Map<String, dynamic>? get visitorInfo => _visitorInfo;

  List<CustomRequests> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  File? image;
  String? status;

  Future<void> fetchRequests(BuildContext context) async {
    final tokenProvider = Provider.of<ProviderLogin>(context, listen: false);
    final token = tokenProvider.token;
    try {
      final response = await http.get(
          Uri.parse('http://localhost:3000/request/user-requests'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _requests = data.map((json) => CustomRequests.fromMap(json)).toList();
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: "Error al obtener solicitudes",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error $e",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteRequest(String id, BuildContext context) async {
    final tokenProvider = Provider.of<ProviderLogin>(context, listen: false);
    final token = tokenProvider.token;
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3000/request/$id'), headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Actualizacion realizado exitosamente",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Error al eliminar el registro",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error $error",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  Future<bool> registerVisit(
      BuildContext context, ProviderRequests provider, String entry) async {
    final date = provider.datevisitController.text;
    final time = provider.timevisitController.text;
    final tokenProvider = Provider.of<ProviderLogin>(context, listen: false);
    final token = tokenProvider.token;
    String base64imagen = "";
    if (provider.image != null) {
      List<int>? imageBytes = await provider.image!.readAsBytes();
      base64imagen = base64Encode(imageBytes);
    }
    try {
      final Map<String, String> header = {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      };

      final Map<String, dynamic> body = {
        "datetime": "$date+$time",
        "resident": provider.dniresidentController.text,
        "visitor": provider.dnivisitorController.text,
        "transportMode": entry,
        "block": provider.blockController.text,
        "villa": provider.villaController.text,
        "photo": base64imagen,
      };
      final response = await http.post(
          Uri.parse('http://localhost:3000/request/'),
          headers: header,
          body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Registro actualizado exitosamente",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: " Error al enviar los datos ",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error $error",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
      return false;
    }
  }

  Future<void> fetchUserById(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/user/{$id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        _visitorInfo = json.decode(response.body);
      } else {
        Fluttertoast.showToast(
          msg: "Error al consultar usuario",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    } catch (e) {
      _errorMessage = 'Error de conexion: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateRequest(ProviderRequests provider, BuildContext context,
      CustomRequests request) async {
    final tokenProvider = Provider.of<ProviderLogin>(context, listen: false);
    final token = tokenProvider.token;
    final Map<String, dynamic> newData = {
      'id': request.id,
      'status': 'accepted',
    };

    final String jsonData = json.encode(newData);
    try {
      final response = await http.patch(
        Uri.parse('http://localhost:3000/request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Actualizacion realizado exitosamente",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
        status = "";
      } else {
        Fluttertoast.showToast(
          msg: "Actualizacion fallida",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    } catch (e) {
      throw Exception('Fallo $e');
    }
  }

  Future<Map<String, String>> fetchVisitorDetails(BuildContext context) async {
    final tokenProvider = Provider.of<ProviderLogin>(context, listen: false);
    final token = tokenProvider.token;
    final response = await http.get(
        Uri.parse('http://localhost:3000/request/user-requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'name': data['name'], 'lastname': data['lastname']};
    } else {
      throw Exception('Error al obtener los detalles del visitante');
    }
  }

  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController get nameController => _nameController;
  set nameController(TextEditingController value) {
    _nameController = value;
    notifyListeners();
  }

  TextEditingController _lastnameController = TextEditingController(text: '');
  TextEditingController get lastnameController => _lastnameController;
  set lastnameController(TextEditingController value) {
    _lastnameController = value;
    notifyListeners();
  }

  TextEditingController _dnivisitorController = TextEditingController(text: '');
  TextEditingController get dnivisitorController => _dnivisitorController;
  set dnivisitorController(TextEditingController value) {
    _dnivisitorController = value;
    notifyListeners();
  }

  TextEditingController _dniresidentController =
      TextEditingController(text: '');
  TextEditingController get dniresidentController => _dniresidentController;
  set dniresidentController(TextEditingController value) {
    _dniresidentController = value;
    notifyListeners();
  }

  TextEditingController _blockController = TextEditingController(text: '');
  TextEditingController get blockController => _blockController;
  set blockController(TextEditingController value) {
    _blockController = value;
    notifyListeners();
  }

  TextEditingController _villaController = TextEditingController(text: '');
  TextEditingController get villaController => _villaController;
  set villaController(TextEditingController value) {
    _villaController = value;
    notifyListeners();
  }

  TextEditingController _datevisitController = TextEditingController(text: '');
  TextEditingController get datevisitController => _datevisitController;
  set datevisitController(TextEditingController value) {
    _datevisitController = value;
    notifyListeners();
  }

  TextEditingController _timevisitController = TextEditingController(text: '');
  TextEditingController get timevisitController => _timevisitController;
  set timevisitController(TextEditingController value) {
    _timevisitController = value;
    notifyListeners();
  }

  void setRequest() {
    _nameController.text = request?.visitorName ?? '';
    _lastnameController.text = request?.visitorLastname ?? '';
    _dnivisitorController.text = request?.visitorDNI ?? '';
    _dniresidentController.text = request?.residentDNI ?? '';
    _blockController.text = request?.block ?? '';
    _villaController.text = request?.villa ?? '';
    _datevisitController.text = request?.datetime.split('+')[0] ?? '';
    _timevisitController.text = request?.datetime.split('+')[1] ?? '';
  }

  cleanInputs() {
    nameController.clear();
    lastnameController.clear();
    dnivisitorController.clear();
    dniresidentController.clear();
    blockController.clear();
    villaController.clear();
    datevisitController.clear();
    timevisitController.clear();
    image = null;
  }
}

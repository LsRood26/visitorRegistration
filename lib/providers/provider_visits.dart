import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:visitorregistration/services/auth_service.dart';
import 'package:visitorregistration/services/http_client.dart';

class ProviderRequests with ChangeNotifier {
  List<CustomRequests> _requests = [];
  CustomRequests? request;

  Map<String, dynamic>? _visitorInfo;
  Map<String, dynamic>? get visitorInfo => _visitorInfo;
  List<CustomRequests> get requests => _requests;

  File? image;
  String? status;
  AuthService auth = AuthService();
  HttpClient client = HttpClient();

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

  Future<void> fetchRequests(BuildContext context) async {
    try {
      final response = await client.get('/request/user-requests');
      final List<dynamic> data = response;
      _requests = data.map((json) => CustomRequests.fromMap(json)).toList();
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al obtener lista de solicitudes",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteRequest(String id, BuildContext context) async {
    try {
      await client.delete('/request/$id');
      Fluttertoast.showToast(
        msg: "Actualizacion realizado exitosamente",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );

      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "No se pudo eliminar la solicitud",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  Future<void> registerVisit(
      BuildContext context, ProviderRequests provider, String entry) async {
    final date = provider.datevisitController.text;
    final time = provider.timevisitController.text;

    String base64imagen = "";
    if (provider.image != null) {
      List<int>? imageBytes = await provider.image!.readAsBytes();
      base64imagen = base64Encode(imageBytes);
    }

    final Map<String, dynamic> body = {
      "datetime": "$date $time",
      "resident": provider.dniresidentController.text,
      "visitor": provider.dnivisitorController.text,
      "transportMode": entry,
      "block": provider.blockController.text,
      "villa": provider.villaController.text,
      "photo": base64imagen,
    };
    try {
      await client.post('/request/', body);
      Fluttertoast.showToast(
        msg: "Solicitud registrada de manera correcta",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al registrar la solicitud",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  Future<void> fetchUserById(String id, String token) async {
    try {
      await client.get('/user/$id');
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al solicitar usuario",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateRequest(ProviderRequests provider, BuildContext context,
      CustomRequests request, String estado) async {
    try {
      final Map<String, dynamic> newData = {
        'id': request.id,
        'status': estado,
      };
      await client.patch('/request', newData);

      Fluttertoast.showToast(
        msg: "Actualizacion realizado exitosamente",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "No se pudo actualizar la solicitud",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  void setRequest() {
    List<String>? datetime = request?.datetime.split(' ');
    _nameController.text = request?.visitorName ?? '';
    _lastnameController.text = request?.visitorLastname ?? '';
    _dnivisitorController.text = request?.visitorDNI ?? '';
    _dniresidentController.text = request?.residentDNI ?? '';
    _blockController.text = request?.block ?? '';
    _villaController.text = request?.villa ?? '';
    _datevisitController.text = datetime?[0] ?? '';
    _timevisitController.text = '${datetime?[1]} ${datetime?[2]}';
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

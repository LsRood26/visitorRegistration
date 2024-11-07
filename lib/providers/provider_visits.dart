import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:visitorregistration/services/http_client.dart';

class ProviderRequests with ChangeNotifier {
  List<CustomRequests> _requests = [];
  CustomRequests? request;

  Map<String, dynamic>? _visitorInfo;
  Map<String, dynamic>? get visitorInfo => _visitorInfo;
  List<CustomRequests> get requests => _requests;

  File? image;
  String? status;
  HttpClient client = HttpClient();

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
}

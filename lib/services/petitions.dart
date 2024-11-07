import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:visitorregistration/services/http_client.dart';
import 'package:flutter/material.dart';

class PetitionsService {
  HttpClient client = HttpClient();

  CustomRequests? request;

  Map<String, dynamic>? _visitorInfo;
  Map<String, dynamic>? get visitorInfo => _visitorInfo;

  Future<void> deleteRequest(String id) async {
    try {
      await client.delete('/request/$id');
      Fluttertoast.showToast(
        msg: "Actualizacion realizado exitosamente",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "No se pudo eliminar la solicitud",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }

  Future<void> registerVisit(
      BuildContext context,
      String entry,
      String datetime,
      String residentId,
      String visitorId,
      String block,
      String villa,
      File? photo) async {
    String base64imagen = "";
    if (photo != null) {
      List<int>? imageBytes = await photo.readAsBytes();
      base64imagen = base64Encode(imageBytes);
    }

    final Map<String, dynamic> body = {
      "datetime": datetime,
      "resident": residentId,
      "visitor": visitorId,
      "transportMode": entry,
      "block": block,
      "villa": villa,
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

  Future<void> updateRequest(
      BuildContext context, CustomRequests request, String estado) async {
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
}

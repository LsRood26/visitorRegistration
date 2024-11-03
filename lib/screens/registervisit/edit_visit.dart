import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditVisit extends StatefulWidget {
  const EditVisit({super.key});

  @override
  State<EditVisit> createState() => _EditVisitState();
}

class _EditVisitState extends State<EditVisit> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

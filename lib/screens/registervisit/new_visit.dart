import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:visitorregistration/providers/provider_visits.dart';
import 'package:visitorregistration/services/petitions.dart';
import 'package:visitorregistration/utils/constants.dart';

enum MetodoIngreso { walk, car }

class NewVisit extends StatefulWidget {
  const NewVisit({
    super.key,
  });

  @override
  State<NewVisit> createState() => _NewVisitState();
}

class _NewVisitState extends State<NewVisit> {
  MetodoIngreso? _metodoSeleccionado = MetodoIngreso.walk;

  late TextEditingController _nameController;

  late TextEditingController _lastnameController;

  late TextEditingController _dnivisitorController;

  late TextEditingController _dniresidentController;

  late TextEditingController _blockController;

  late TextEditingController _villaController;

  late TextEditingController _datevisitController;

  late TextEditingController _timevisitController;

  late bool isEditing;
  late int roleId;
  late String photo;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (arguments != null) {
        List<String> parts = arguments['datetime'].split(' ');
        isEditing = arguments['isEditing'] ?? false;
        roleId = arguments['userRoleId'] ?? '';
        photo = arguments['photo'] ?? '';

        _nameController = TextEditingController(
            text: isEditing ? arguments['visitorName'].toString() : '');
        _lastnameController = TextEditingController(
            text: isEditing ? arguments['visitorLastname'].toString() : '');
        _dnivisitorController = TextEditingController(
            text: isEditing ? arguments['visitorDNI'].toString() : '');
        _dniresidentController = TextEditingController(
            text: isEditing ? arguments['residentDNI'].toString() : '');
        _blockController = TextEditingController(
            text: isEditing ? arguments['block'].toString() : '');
        _villaController = TextEditingController(
            text: isEditing ? arguments['villa'].toString() : '');
        _datevisitController =
            TextEditingController(text: isEditing ? parts[0] : '');
        _timevisitController =
            TextEditingController(text: isEditing ? parts[1] : '');
      } else {
        isEditing = false;
        _nameController = TextEditingController();
        _lastnameController = TextEditingController();
        _dnivisitorController = TextEditingController();
        _dniresidentController = TextEditingController();
        _blockController = TextEditingController();
        _villaController = TextEditingController();
        _datevisitController = TextEditingController();
        _timevisitController = TextEditingController();
        photo = '';
        roleId = 0;
      }

      _initialized = true;
    }
  }

  handleSetMethod(MetodoIngreso method) => setState(() {
        _metodoSeleccionado = method;
      });

  @override
  Widget build(BuildContext context) {
    Uint8List imageDecoded = base64Decode(photo);
    String entry = "";
    final size = MediaQuery.of(context).size;
    Constants constants = Constants();
    PetitionsService petitions = PetitionsService();
    File? image;
    final requestProvider = Provider.of<ProviderRequests>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Colors.white,
        title: Text(isEditing ? 'Editar visita' : 'Registrar nueva visita'),
      ),
      body: Container(
        height: size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dataText(
                size, 'Nombres del visitante', 0.6, _nameController, isEditing),
            dataText(size, 'Apellidos del visitante', 0.6, _lastnameController,
                isEditing),
            dataText(size, 'Cedula del visitante', 0.6, _dnivisitorController,
                isEditing),
            dataText(size, 'Cedula del residente', 0.6, _dniresidentController,
                isEditing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dataText(size, 'Manzana', 0.3, _blockController, isEditing),
                dataText(size, 'Villa', 0.3, _villaController, isEditing)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Fecha de visita'),
                    controller: _datevisitController,
                    readOnly: true,
                    onTap: () {
                      selectDate(context, _datevisitController);
                    },
                  ),
                ),
                Container(
                  width: size.width * 0.3,
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      selectTime(context, _timevisitController);
                    },
                    decoration: InputDecoration(hintText: 'Hora de visita'),
                    controller: _timevisitController,
                  ),
                ),
              ],
            ),
            const Text(
              'Medio de ingreso',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                radioSelection(size, handleSetMethod, 'Caminando',
                    MetodoIngreso.walk, _metodoSeleccionado!),
                radioSelection(size, handleSetMethod, 'Con Vehículo',
                    MetodoIngreso.car, _metodoSeleccionado!),
              ],
            ),
            if (roleId == constants.ID_VISITANTE &&
                _metodoSeleccionado == MetodoIngreso.car) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * 0.4,
                      child: Text('Cargar foto de placa de vehiculo')),
                  Container(
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        _pickImage(image);
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.purple)),
                  height: size.height * 0.15,
                  width: size.width * 0.5,
                  child: photo.isEmpty
                      ? Image.memory(imageDecoded)
                      : Icon(Icons.photo))
            ]
          ],
        ),
      ),
      floatingActionButton: Container(
        height: size.height * 0.05,
        width: size.width * 0.35,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () async {
            if (_metodoSeleccionado == MetodoIngreso.car) {
              entry = 'car';
            } else {
              entry = "walk";
            }
            String datetime =
                '${_datevisitController.text} ${_timevisitController.text}';
            String residentId = _dniresidentController.text;
            String visitorId = _dnivisitorController.text;
            String block = _blockController.text;
            String villa = _villaController.text;
            File? photo = image;

            await petitions.registerVisit(context, entry, datetime, residentId,
                visitorId, block, villa, photo);

            await requestProvider.fetchRequests(context);

            Navigator.pop(context, true);
          },
          child: Text(
            isEditing ? 'Editar visita' : 'Registrar visita',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(File? file) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  Widget dataText(Size size, String hint, double width,
      TextEditingController controller, bool isEditing) {
    return Container(
      padding: EdgeInsets.all(8),
      height: size.height * 0.08,
      width: size.width * width,
      child: Column(
        children: [
          TextField(
            readOnly: isEditing == true,
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (pickedDate != null) {
      dateController.text = pickedDate.toIso8601String().split('T')[0];
    }
  }

  Future<void> selectTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      timeController.text = pickedTime.format(context);
    }
  }

  Widget radioSelection(Size size, Function func, String text,
      MetodoIngreso method, MetodoIngreso selectedmethod) {
    return Container(
      width: size.width * 0.5,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: size.height * 0.018),
        ),
        leading: Radio(
            value: method,
            groupValue: selectedmethod,
            onChanged: (MetodoIngreso? value) {
              func(value);
            }),
      ),
    );
  }
}

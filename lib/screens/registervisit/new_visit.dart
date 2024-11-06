import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/models/users.dart';
import 'dart:io';

import 'package:visitorregistration/providers/provider_visits.dart';
import 'package:visitorregistration/utils/constants.dart';

enum MetodoIngreso { walk, car }

class NewVisit extends StatefulWidget {
  const NewVisit({super.key});

  @override
  State<NewVisit> createState() => _NewVisitState();
}

class _NewVisitState extends State<NewVisit> {
  MetodoIngreso? _metodoSeleccionado = MetodoIngreso.walk;

  handleSetMethod(MetodoIngreso method) => setState(() {
        _metodoSeleccionado = method;
      });

  @override
  Widget build(BuildContext context) {
    String entry = "";
    final size = MediaQuery.of(context).size;
    ProviderRequests provider = Provider.of<ProviderRequests>(context);
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    Constants constants = Constants();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            provider.request = null;
            Navigator.of(context).pop();
            provider.cleanInputs();
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Colors.white,
        title: Text(provider.request != null
            ? 'Editar visita'
            : 'Registrar nueva visita'),
      ),
      body: Container(
        height: size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dataText(size, 'Nombres del visitante', 0.6,
                provider.nameController, provider),
            dataText(size, 'Apellidos del visitante', 0.6,
                provider.lastnameController, provider),
            dataText(size, 'Cedula del visitante', 0.6,
                provider.dnivisitorController, provider),
            dataText(size, 'Cedula del residente', 0.6,
                provider.dniresidentController, provider),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dataText(
                    size, 'Manzana', 0.3, provider.blockController, provider),
                dataText(size, 'Villa', 0.3, provider.villaController, provider)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Fecha de visita'),
                    controller: provider.datevisitController,
                    readOnly: true,
                    onTap: () {
                      selectDate(context, provider);
                    },
                  ),
                ),
                Container(
                  width: size.width * 0.3,
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      selectTime(context, provider);
                    },
                    decoration: InputDecoration(hintText: 'Hora de visita'),
                    controller: provider.timevisitController,
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
                radioSelection(size, handleSetMethod, 'Con Vehiculo',
                    MetodoIngreso.car, _metodoSeleccionado!),
              ],
            ),
            if (user.role.id == constants.ID_VISITANTE &&
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
                        _pickImage(provider);
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
                  child: provider.image != null
                      ? Image.file(
                          provider.image!,
                          fit: BoxFit.cover,
                        )
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
            provider.request = null;
            if (_metodoSeleccionado == MetodoIngreso.car) {
              entry = 'car';
            } else {
              entry = "walk";
            }
            await provider.registerVisit(context, provider, entry);

            provider.cleanInputs();
            provider.fetchRequests(context);
            Navigator.pop(context, true);
          },
          child: Text(
            provider.request != null ? 'Editar visita' : 'Registrar visita',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ProviderRequests provider) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        provider.image = File(pickedFile.path);
      });
    }
  }
}

Widget dataText(Size size, String hint, double width,
    TextEditingController controller, ProviderRequests provider) {
  return Container(
    padding: EdgeInsets.all(8),
    height: size.height * 0.08,
    width: size.width * width,
    child: Column(
      children: [
        TextField(
          readOnly: provider.request != null,
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    ),
  );
}

Future<void> selectDate(BuildContext context, ProviderRequests provider) async {
  final DateTime? pickedDate = await showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
  if (pickedDate != null) {
    provider.datevisitController.text =
        pickedDate.toIso8601String().split('T')[0];
  }
}

Future<void> selectTime(BuildContext context, ProviderRequests provider) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null) {
    provider.timevisitController.text = pickedTime.format(context);
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

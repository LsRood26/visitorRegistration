import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum MetodoIngreso { caminando, vehiculo }

class NewVisit extends StatefulWidget {
  const NewVisit({super.key});

  @override
  State<NewVisit> createState() => _NewVisitState();
}

class _NewVisitState extends State<NewVisit> {
  MetodoIngreso? _metodoSeleccionado = MetodoIngreso.caminando;
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
    String usertype = 'visitante';
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Registrar nueva visita'),
      ),
      body: Container(
        height: size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dataText(size, 'Nombre y apellido del visitante',
                'Nombre y apellido del visitante', 0.6),
            dataText(size, 'Cedula del visitante', 'Cedula del visitante', 0.6),
            dataText(size, 'Cedula del residente', 'Cedula del residente', 0.6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dataText(size, 'Manzana del residente', 'Manzana', 0.3),
                dataText(size, 'Villa del residente', 'Villa', 0.3)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    selectDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      'Fecha de visita',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    selectTime(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        'Hora de visita',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
            Text('Medio de ingreso'),
            Row(
              children: [
                Container(
                  width: size.width * 0.5,
                  child: ListTile(
                    title: Text(
                      'Caminando',
                      style: TextStyle(fontSize: size.height * 0.018),
                    ),
                    leading: Radio(
                        value: MetodoIngreso.caminando,
                        groupValue: _metodoSeleccionado,
                        onChanged: (MetodoIngreso? value) {
                          setState(() {
                            _metodoSeleccionado = value;
                            print(_metodoSeleccionado);
                          });
                        }),
                  ),
                ),
                Container(
                  width: size.width * 0.5,
                  child: ListTile(
                    title: Text(
                      'Con vehiculo',
                      style: TextStyle(fontSize: size.height * 0.018),
                    ),
                    leading: Radio(
                        value: MetodoIngreso.vehiculo,
                        groupValue: _metodoSeleccionado,
                        onChanged: (MetodoIngreso? value) {
                          setState(() {
                            _metodoSeleccionado = value;
                            print(_metodoSeleccionado);
                          });
                        }),
                  ),
                ),
              ],
            ),
            if (usertype == 'visitante' &&
                _metodoSeleccionado == MetodoIngreso.vehiculo) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * 0.4,
                      child: Text('Cargar foto de placa de vehiculo')),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        _pickImage();
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              Container(
                  height: size.height * 0.15,
                  width: size.width * 0.5,
                  child: _image != null
                      ? Image.file(
                          _image!,
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
          onPressed: () {
            //GUARDAR LA INFORMACION
          },
          child: Text(
            'Registrar visita',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Widget dataText(Size size, String texto, String hint, double width
    /* TextEditingController controller */
    ) {
  return Container(
    //color: Colors.amber,
    padding: EdgeInsets.all(8),
    height: size.height * 0.08,
    width: size.width * width,
    child: Column(
      children: [
        //Text(texto),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    ),
  );
}

Future<void> selectDate(BuildContext context) async {
  //GUARDAR CON PROVIDER
  final DateTime? pickedDate = await showDatePicker(
      //locale: ,
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));
  if (pickedDate != null) {
    print('Fecha seleccionada: $pickedDate');
  }
}

Future<void> selectTime(BuildContext context) async {
  //GUARDAR CON PROVIDER
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null) {
    print('Hora seleccionada: ${pickedTime.format(context)}');
  }
}

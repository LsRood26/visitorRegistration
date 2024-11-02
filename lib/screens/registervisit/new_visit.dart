import 'package:flutter/material.dart';

enum MetodoIngreso { caminando, vehiculo }

class NewVisit extends StatefulWidget {
  const NewVisit({super.key});

  @override
  State<NewVisit> createState() => _NewVisitState();
}

class _NewVisitState extends State<NewVisit> {
  MetodoIngreso? _metodoSeleccionado = MetodoIngreso.caminando;
  @override
  Widget build(BuildContext context) {
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
                'Nombre y apellido del visitante', 0.8),
            dataText(size, 'Cedula del visitante', '112233445566', 0.6),
            dataText(size, 'Cedula del residente', '009988776655', 0.6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dataText(size, 'Manzana del residente', 'L', 0.3),
                dataText(size, 'Villa del residente', '15', 0.3)
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
            Container(
              color: Colors.amber,
              child: Column(
                children: [
                  Text('Medio de ingreso'),
                  Row(
                    children: [
                      Container(
                        //color: Colors.blue,
                        width: size.width * 0.5,
                        child: ListTile(
                          title: Text('Caminando'),
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
                        //color: Colors.blue,
                        width: size.width * 0.5,
                        child: ListTile(
                          title: Text('Con vehiculo'),
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: size.width * 0.35,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {},
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
    padding: EdgeInsets.all(8),
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

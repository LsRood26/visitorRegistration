import 'package:flutter/material.dart';

class VisitorHome extends StatefulWidget {
  const VisitorHome({super.key});

  @override
  State<VisitorHome> createState() => _VisitorHomeState();
}

class _VisitorHomeState extends State<VisitorHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Hola, John Doe'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
            width: size.width * 0.4,
            decoration: BoxDecoration(
                color: Colors.purple, borderRadius: BorderRadius.circular(12)),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newvisit');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    'Nueva Visita',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          registervisits(size, _tabController),
        ],
      ),
    );
  }
}

Widget registervisits(Size size, TabController controller) {
  return Column(
    children: [
      Container(
        width: size.width * 1,
        child: TabBar(
          labelColor: Colors.purple,
          dividerColor: Colors.purple,
          indicatorColor: Colors.purple,
          controller: controller,
          tabs: const [
            Tab(
              icon: Icon(Icons.pending_actions),
              child: Wrap(
                children: [
                  Text(
                    'Solicitudes de visitas pendientes',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Tab(
              icon: Icon(Icons.history),
              child: Wrap(
                children: [
                  Text(
                    'Registro de visitas',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        //color: Colors.blue,
        //width: size.width * 0.9,
        height: size.height * 0.5,
        child: TabBarView(
          controller: controller,
          children: [
            Center(
              child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return pendingvisits(size, context);
                  }),
            ),
            Center(
              child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return previousvisits(size, context);
                  }),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget pendingvisits(Size size, BuildContext context) {
  return GestureDetector(
    onTap: () {
      showPendingVisits(context, size);
    },
    child: Card(
      child: ListTile(
        title: Text('Jane Doe'),
        subtitle: Text('11-1-2024 09:11'),
        trailing: IconButton(
            onPressed: () {
              print('Editando');
            },
            icon: Icon(Icons.edit)),
      ),
    ),
  );
}

Widget previousvisits(Size size, BuildContext context) {
  return GestureDetector(
    onTap: () {
      print('Informacion de la visita previa der John');
      showPreviousVisits(context, size);
    },
    child: const Card(
      child: ListTile(
        title: Text('John Doe'),
        subtitle: Text('10-20-2024 07:30'),
        trailing: Icon(Icons.check),
      ),
    ),
  );
}

Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Datos cargados';
}

void showPendingVisits(
    BuildContext context, Size size /* , Provider provider */) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  title: Text('Cargando...'),
                  content: Container(
                    height: size.height * 0.5,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Container(
                      height: size.height * 0.4,
                      child: Text('No se puede mostrar la informacion')),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text('Detalles de solicitud'),
                  content: Container(
                    height: size.height * 0.43,
                    child: Column(
                      children: [
                        Text('Nombres visitantes'),
                        Text('Jane Doe'),
                        Text('Cedula visitantes'),
                        Text('1312788357'),
                        Text('Fecha y Hora de visita'),
                        Text('11/1/2024 - 09:00 AM'),
                        Text('Medio de ingreso'),
                        Text('Vehiculo'),
                        Image(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi1Z4Y2EHenGzuEOmPVPMBulMIVYI-xdpIxA&s'),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          deleteconfirmationdiag(context);
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.red,
                        ))
                  ],
                );
              }
            });
      });
}

void deleteconfirmationdiag(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar solicitud de visita?'),
          actions: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Si',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'))
          ],
        );
      });
}

void showPreviousVisits(
    BuildContext context, Size size /* , Provider provider */) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  title: Text('Cargando...'),
                  content: Container(
                    height: size.height * 0.45,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Container(
                      height: size.height * 0.4,
                      child: Text('No se puede mostrar la informacion')),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text('Detalles de solicitud'),
                  content: Container(
                    height: size.height * 0.4,
                    child: Column(
                      children: [
                        Text('Nombres visitantes'),
                        Text('Jane Doe'),
                        Text('Cedula visitantes'),
                        Text('1312788357'),
                        Text('Fecha y Hora de visita'),
                        Text('11/1/2024 - 09:00 AM'),
                        Text('Medio de ingreso'),
                        Text('Vehiculo'),
                        Image(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi1Z4Y2EHenGzuEOmPVPMBulMIVYI-xdpIxA&s'),
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
      });
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:visitorregistration/providers/provider_login.dart';
import 'package:visitorregistration/providers/provider_visits.dart';
import 'package:visitorregistration/services/auth_service.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({super.key});

  @override
  State<ResidentHome> createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print('Hola');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderRequests>(context, listen: false)
          .fetchRequests(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Hola');
    Provider.of<ProviderRequests>(context, listen: false)
        .fetchRequests(context);
  } */

  @override
  Widget build(BuildContext context) {
    final AuthService service = AuthService();
    final size = MediaQuery.of(context).size;
    final requestProvider = Provider.of<ProviderRequests>(context);
    final authprovider = Provider.of<ProviderLogin>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Bienvenido, ${authprovider.getname}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                service.logout(context);
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
          /* IconButton(
            onPressed: () {
              requestProvider.fetchRequests(context);
            },
            icon: Icon(Icons.abc),
          ), */
          SizedBox(
            height: size.height * 0.03,
          ),
          Container(
              //color: Colors.amber,
              height: size.height * 0.75,
              width: size.width * 1,
              child: registervisitors(size, _tabController, requestProvider)),
        ],
      ),
    );
  }
}

Widget registervisitors(
    Size size, TabController controller, ProviderRequests provider) {
  String filterPending = 'pending';

  List<CustomRequests> allRequests = provider.requests;
  List<CustomRequests> filteredRequests =
      allRequests.where((request) => request.status == filterPending).toList();
  List<CustomRequests> remainingRequest =
      allRequests.where((request) => request.status != filterPending).toList();
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
      Expanded(
        child: TabBarView(
          controller: controller,
          children: [
            Container(
              //color: Colors.purple,
              height: size.height * 0.6,
              child: filteredRequests.isEmpty
                  ? Center(
                      child: Text('No tienes visitas pendientes'),
                    )
                  : ListView.builder(
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return GestureDetector(
                          onLongPress: () {
                            print('JOJO');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Esta seguro de eliminar la solicitud?'),
                                  actions: [
                                    IconButton(
                                      onPressed: () async {
                                        await provider.deleteRequest(
                                            request.id.toString(), context);
                                        provider.fetchRequests(context);
                                      },
                                      icon: Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            showDetailsDialog(context, request, size, provider);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  '${request.visitorName + request.visitorLastname}'),
                              subtitle: Text('${request.datetime}'),
                              trailing: GestureDetector(
                                  onTap: () {
                                    provider.request = request;
                                    provider.setRequest();
                                    Navigator.pushNamed(context, '/newvisit');
                                    print('Editando');
                                  },
                                  child: Icon(Icons.edit)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              height: size.height * 0.6,
              child: provider.requests.isEmpty
                  ? Center(
                      child: Text('No tienes registros de visitas'),
                    )
                  : ListView.builder(
                      itemCount: remainingRequest.length,
                      itemBuilder: (context, index2) {
                        final requestpre = remainingRequest[index2];
                        return GestureDetector(
                          onTap: () {
                            showDetailsDialog(
                                context, requestpre, size, provider);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text('${requestpre.visitorName}'),
                              subtitle: Text('${requestpre.datetime}'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ],
  );
}

void showDetailsDialog(BuildContext context, CustomRequests request, Size size,
    ProviderRequests provider) {
  String base64Image = request.photo;
  print(' base641 $base64Image');
  String base64String = base64Image.split(',').last;
  print(' base642 $base64String');
  Uint8List bytes = base64Decode(base64String);
  print('bytes $bytes');
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de visitante'),
          content: Container(
            height: size.height * 0.3,
            child: Column(
              children: [
                Text('${request.visitorName}'),
                Text('${request.visitorDNI}'),
                Text('${request.residentDNI}'),
                Text('${request.datetime}'),
                Text('${request.transportMode}'),
                Text('${request.status}'),
                Image(
                  image: MemoryImage(bytes),
                  width: size.width * 0.3,
                  height: size.height * 0.15,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          actions: [
            Text('Aceptar visita?'),
            IconButton(
                onPressed: () async {
                  provider.status = 'accepted';
                  await provider.updateRequest(provider, context, request);
                  provider.fetchRequests(context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check)),
            IconButton(
                onPressed: () async {
                  provider.status = 'rejected';
                  await provider.updateRequest(provider, context, request);
                  provider.fetchRequests(context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        );
      });
}

Widget pendingvisitors(Size size, BuildContext context, CustomRequests request,
    ProviderRequests provider) {
  return FutureBuilder(
      future: provider.fetchVisitorDetails(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text('Cargando detalles'),
            subtitle: Text('Fecha: ${request.datetime}'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error al cargar los detalles'),
            subtitle: Text('Fecha: ${request.datetime}'),
          );
        } else {
          final name = snapshot.data!['name']!;
          final lastname = snapshot.data!['lastname']!;

          return ListTile(
            title: Text('Visitante: $name $lastname'),
            subtitle: Text('Fecha: ${request.datetime}'),
            trailing: IconButton(
                onPressed: () {
                  print('Editando');
                },
                icon: Icon(Icons.edit)),
          );
        }
      });
}

Widget previousvisitors(Size size, BuildContext context) {
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
  await Future.delayed(Duration(seconds: 2));
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
                    Text('Aprobar visita?'),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.check),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close))
                  ],
                );
              }
            });
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

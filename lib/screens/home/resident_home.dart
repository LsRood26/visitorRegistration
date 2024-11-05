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
              child: const Row(
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
          SizedBox(
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Esta seguro de eliminar la solicitud?'),
                                  actions: [
                                    IconButton(
                                      onPressed: () async {
                                        await provider.deleteRequest(
                                            request.id.toString(), context);
                                        provider.fetchRequests(context);
                                      },
                                      icon: const Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close),
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
  String base64String = base64Image.split(',').last;
  Uint8List bytes = base64Decode(base64String);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles de visitante'),
          content: Container(
            height: size.height * 0.3,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Nombre del visitante: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${request.visitorName} ${request.visitorLastname}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Cedula visitante: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${request.visitorDNI}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Cedula residente: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${request.residentDNI}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Fecha y Hora: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${request.datetime}'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Medio de ingreso: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //Text('${request.transportMode}'),
                    Text(request.transportMode == 'car'
                        ? 'Vehiculo'
                        : 'Caminando'),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Estado de solicitud: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(request.status == 'pending'
                        ? 'Pendiente'
                        : request.status == 'accepted'
                            ? 'Aceptado'
                            : 'Denegado'),
                  ],
                ),
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
            const Text(
              'Aceptar visita?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () async {
                  provider.status = 'accepted';
                  await provider.updateRequest(provider, context, request);
                  provider.fetchRequests(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check)),
            IconButton(
                onPressed: () async {
                  provider.status = 'rejected';
                  await provider.updateRequest(provider, context, request);
                  provider.fetchRequests(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        );
      });
}

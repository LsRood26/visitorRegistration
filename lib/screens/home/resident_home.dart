import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/models/requests.dart';
import 'package:visitorregistration/models/users.dart';
import 'package:visitorregistration/providers/provider_visits.dart';
import 'package:visitorregistration/services/auth_service.dart';
import 'package:visitorregistration/services/http_client.dart';
import 'package:visitorregistration/services/petitions.dart';
import 'package:visitorregistration/utils/constants.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({super.key});

  @override
  State<ResidentHome> createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (HttpClient().getToken() != null) {
        /* Provider.of<ProviderRequests>(context, listen: false)
            .fetchRequests(context); */
        _loadRequest();
      }
    });
  }

  Future<void> _loadRequest() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<ProviderRequests>(context, listen: false)
        .fetchRequests(context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    final AuthService service = AuthService();
    final size = MediaQuery.of(context).size;
    final requestProvider = Provider.of<ProviderRequests>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Bienvenido, ${user.name} ${user.lastName}'),
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
          /* Container(
              color: Colors.blue,
              height: size.height * 0.75,
              width: size.width * 1,
              child: registervisitors(
                  size, _tabController, requestProvider, user)), */
          Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : registervisitors(
                      size, _tabController, requestProvider, user)),
        ],
      ),
    );
  }
}

Widget registervisitors(
    Size size, TabController controller, ProviderRequests provider, User user) {
  Constants constants = Constants();
  List<CustomRequests> allRequests = provider.requests;
  List<CustomRequests> filteredRequests = allRequests
      .where((request) => request.status == constants.PENDING)
      .toList();
  List<CustomRequests> remainingRequest = allRequests
      .where((request) => request.status != constants.PENDING)
      .toList();
  PetitionsService _petitions = PetitionsService();
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
                    'Solicitudes de visita pendientes',
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
                                      '¿Estas seguro de eliminar la solicitud?'),
                                  actions: [
                                    IconButton(
                                      onPressed: () async {
                                        await _petitions.deleteRequest(
                                            request.id.toString());
                                        await provider.fetchRequests(context);

                                        Navigator.pop(context);
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
                            showDetailsDialog(
                                context, request, size, provider, user);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  '${request.visitorName + request.visitorLastname}'),
                              subtitle: Text('${request.datetime}'),
                              trailing: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/newvisit',
                                        arguments: {
                                          'isEditing': true,
                                          'userRoleId': user.role.id,
                                          'id': request.id,
                                          'datetime': request.datetime,
                                          'photo': request.photo,
                                          'status': request.status,
                                          'transportMode':
                                              request.transportMode,
                                          'residentDNI': request.residentDNI,
                                          'visitorDNI': request.visitorDNI,
                                          'visitorName': request.visitorName,
                                          'visitorLastname':
                                              request.visitorLastname,
                                          'block': request.block,
                                          'villa': request.villa,
                                        });
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
              child: remainingRequest.isEmpty
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
                                context, requestpre, size, provider, user);
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
    ProviderRequests provider, User user) {
  String base64Image = request.photo;
  String base64String = base64Image.split(',').last;
  Uint8List bytes = base64Decode(base64String);
  Constants constants = Constants();
  PetitionsService petitions = PetitionsService();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del visitante'),
          content: Container(
            height: size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textTitle('Nombre del visitante: ',
                    '${request.visitorName} ${request.visitorLastname}'),
                textTitle('Cedula del visitante: ', '${request.visitorDNI}'),
                textTitle('Cedula del residente: ', '${request.residentDNI}'),
                textTitle('Fecha y Hora visita: ', '${request.datetime}'),
                textTitle('Medio de ingreso: ',
                    request.transportMode == 'car' ? 'Vehiculo' : 'Caminando'),
                textTitle(
                    'Estado de solicitud: ',
                    request.status == constants.PENDING
                        ? 'Pendiente'
                        : request.status == constants.ACCEPTED
                            ? 'Aceptado'
                            : 'Denegado'),
                if (request.photo != '') ...[
                  Image(
                    image: MemoryImage(bytes),
                    width: size.width * 0.3,
                    height: size.height * 0.15,
                    fit: BoxFit.cover,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (request.status == constants.PENDING &&
                user.role.id == constants.ID_RESIDENTE) ...[
              const Text(
                '¿Aceptar visita?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () async {
                    await petitions.updateRequest(
                        context, request, constants.ACCEPTED);
                    /* await provider.updateRequest(
                        provider, context, request, constants.ACCEPTED); */
                    await provider.fetchRequests(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check)),
              IconButton(
                  onPressed: () async {
                    await petitions.updateRequest(
                        context, request, constants.REJECTED);
                    /* await provider.updateRequest(
                        provider, context, request, constants.REJECTED); */
                    //petitions.fetchRequests();
                    await provider.fetchRequests(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ]
          ],
        );
      });
}

Widget textTitle(String title, String subtitle) {
  return Row(
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(subtitle),
    ],
  );
}

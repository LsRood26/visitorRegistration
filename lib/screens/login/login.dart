import 'package:flutter/material.dart';
import 'package:visitorregistration/services/auth_service.dart';

class LoginOptionsPage extends StatefulWidget {
  const LoginOptionsPage({super.key});

  @override
  State<LoginOptionsPage> createState() => _LoginOptionsPageState();
}

class _LoginOptionsPageState extends State<LoginOptionsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width * 1,
        height: size.height * 1,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.location_city),
                Text('Urbanización Denme Chamba'),
              ],
            ),
            InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, '/residenthome');
                  Navigator.pushNamed(context, '/loginpassword');
                },
                child: loginOption(
                    'Cedula y Contrasenia', Icon(Icons.people), size)),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/residenthome');
                },
                child: loginOption('Biometrico', Icon(Icons.face), size))
          ],
        ),
      ),
    );
  }
}

Widget loginOption(String texto, Icon icon, Size size) {
  return Container(
    width: size.width * 0.35,
    height: size.height * 0.15,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
        )),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.height * 0.02,
            color: Colors.black,
          ),
        )
      ],
    ),
  );
}

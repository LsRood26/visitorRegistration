import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/providers/provider_login.dart';

class LoginPasswordPage extends StatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  State<LoginPasswordPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderLogin>(context);
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
                Icon(Icons.ac_unit_sharp),
                Text('Urbanización Denme Chamba'),
              ],
            ),
            Container(
              width: size.width * 0.5,
              child: TextField(
                controller: provider.dniController,
                decoration: InputDecoration(hintText: 'Cédula de Identidad'),
              ),
            ),
            Container(
              width: size.width * 0.5,
              child: TextField(
                controller: provider.passwordController,
                decoration: InputDecoration(hintText: 'Contraseña'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.purple,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/residenthome');
                  //Navigator.pushNamed(context, '/visitorhome');
                },
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

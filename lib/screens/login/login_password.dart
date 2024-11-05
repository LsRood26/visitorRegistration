import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/providers/provider_login.dart';
import 'package:visitorregistration/services/auth_service.dart';

class LoginPasswordPage extends StatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  State<LoginPasswordPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPasswordPage> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderLogin>(context);
    final AuthService service = AuthService();
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
                  setState(() {
                    isLoading = true;
                  });
                  service.login(provider.dniController.text,
                      int.parse(provider.passwordController.text), context);
                  setState(() {
                    isLoading = false;
                  });
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

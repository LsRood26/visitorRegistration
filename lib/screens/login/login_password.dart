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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderLogin>(context);
    final AuthService service = AuthService();
    return Scaffold(
      body: Container(
        width: size.width * 1,
        height: size.height * 1,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              titles('Urbanizacion ', 'Registro de visitas'),
              Container(
                width: size.width * 0.5,
                child: TextFormField(
                  controller: provider.dniController,
                  decoration: InputDecoration(hintText: 'Cédula de Identidad'),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cédula no valida';
                    }
                    if (value.length != 10) {
                      return 'Cédula no valida';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'La cédula solo debe contener números';
                    }
                    return null;
                  },
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
                width: size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple,
                ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                    service.login(provider.dniController.text,
                        provider.passwordController.text, context);
                  },
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget titles(String urbName, String text) {
  return Column(
    children: [
      const Icon(Icons.location_city),
      Text(
        urbName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    ],
  );
}

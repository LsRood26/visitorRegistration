import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitorregistration/providers/provider_login.dart';
import 'package:visitorregistration/providers/provider_visits.dart';
import 'package:visitorregistration/screens/home/resident_home.dart';
import 'package:visitorregistration/screens/login/login.dart';
import 'package:visitorregistration/screens/login/login_password.dart';
import 'package:visitorregistration/screens/registervisit/new_visit.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProviderLogin()),
    ChangeNotifierProvider(create: (_) => ProviderRequests()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visitor Registration',
      home: LoginOptionsPage(),
      initialRoute: '/',
      routes: {
        //'/': (context) => const LoginOptionsPage(),
        '/loginpassword': (context) => const LoginPasswordPage(),
        '/residenthome': (context) => const ResidentHome(),
        '/newvisit': (context) => const NewVisit(),
      },
    );
  }
}

import 'package:visitorregistration/models/role.dart';

class User {
  final String dni;
  final String name;
  final String lastName;
  final Role role;
  final String accessToken;

  User(
      {required this.dni,
      required this.name,
      required this.lastName,
      required this.role,
      required this.accessToken});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        dni: map['dni'],
        name: map['name'],
        lastName: map['lastname'],
        role: Role.fromMap(
          map['role'],
        ),
        accessToken: map['access_token']);
  }

  Map<String, dynamic> toMap() {
    return {
      'dni': dni,
      'name': name,
      'lastname': lastName,
      'role': role.toMap(),
      'access_token': accessToken
    };
  }
}

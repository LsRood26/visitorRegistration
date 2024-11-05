class User {
  final String dni;
  final String name;
  final String lastName;
  final int role;

  User(
      {required this.dni,
      required this.name,
      required this.lastName,
      required this.role});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        dni: map['dni'],
        name: map['name'],
        lastName: map['lastname'],
        role: map['roleId']);
  }

  Map<String, dynamic> toMap() {
    return {'dni': dni, 'name': name, 'lastname': lastName, 'roleId': role};
  }
}

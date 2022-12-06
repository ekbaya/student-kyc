import 'dart:convert';

class User {
  String name;
  String password;
  String email;
  String registration;
  String feebalance;
  List modelData;

  User({
    required this.name,
    required this.password,
    required this.modelData,
    required this.email,
    required this.registration,
    required this.feebalance,
  });

  static User fromMap(Map<String, dynamic> name) {
    return User(
        name: name['name'],
        password: name['password'],
        modelData: jsonDecode(name['model_data']),
        email: name['email'],
        registration: name['registration'],
        feebalance: name['feebalance']);
  }

  toMap() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'registration': registration,
      'feebalance': feebalance,
      'model_data': jsonEncode(modelData),
    };
  }
}

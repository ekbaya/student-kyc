// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Account {
  final String name;
  final String password;
  final String email;
  final String registration;
  final List modelData;
  Account({
    required this.name,
    required this.password,
    required this.email,
    required this.registration,
    required this.modelData,
  });

  Account copyWith({
    String? name,
    String? password,
    String? email,
    String? registration,
    List? modelData,
  }) {
    return Account(
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      registration: registration ?? this.registration,
      modelData: modelData ?? this.modelData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'password': password,
      'email': email,
      'registration': registration,
      'model_data': modelData,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        name: map['name'] as String,
        password: map['password'] as String,
        email: map['email'] as String,
        registration: map['registration'] as String,
        modelData: List.from((map['model_data'] as List)));
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(name: $name, password: $password, email: $email, registration: $registration, modelData: $modelData)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.password == password &&
        other.email == email &&
        other.registration == registration &&
        listEquals(other.modelData, modelData);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        password.hashCode ^
        email.hashCode ^
        registration.hashCode ^
        modelData.hashCode;
  }
}

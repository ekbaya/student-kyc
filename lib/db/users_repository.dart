import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_kyc_app/models/user.model.dart';

Future<List<User>> getUsers() {
  FirebaseFirestore db = FirebaseFirestore.instance;
  return db
      .collection("users")
      .get()
      .then((value) => value.docs.map((e) => User.fromMap(e.data())).toList());
}

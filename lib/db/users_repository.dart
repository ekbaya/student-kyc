import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_kyc_app/models/user.model.dart';

Future<List<Account>> getUsers() {
  FirebaseFirestore db = FirebaseFirestore.instance;
  return db.collection("users").get().then(
      (value) => value.docs.map((e) => Account.fromMap(e.data())).toList());
}

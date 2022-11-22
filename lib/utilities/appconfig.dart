import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin AppConfig {
  //firebase
  static FirebaseFirestore firebaseFiretore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
}

String mapKey = "AIzaSyBDOjOJB4-uVM2YssqKA0KNOwv8WSRxBd4";

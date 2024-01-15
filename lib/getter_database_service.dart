import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GetDataFromFirebase
{
  final database_cloud_firestore = FirebaseFirestore.instance;
  Future<Map<String, int>> getUserData() async
  {
    var user_data = await database_cloud_firestore.collection("users").doc("email").get().then((value) => value.data());
    Map<String,int> abc = {...user_data!};
    print(user_data);
    return abc;
  }
}
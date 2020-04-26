import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseStore {
  Future<DocumentSnapshot> getUserById(String id);
  Future<List<DocumentSnapshot>> getAllUsers();
  Future<void> updateUser(String id,String name);
  Future<void> updateImagePath(String id,String path);
}

class Store implements BaseStore {

  final Firestore _fireStore = Firestore.instance;

  Future<List<DocumentSnapshot>> getAllUsers() async {
     print("getAllUsers--------");


     QuerySnapshot querySnapshot = await Firestore.instance.collection("users").getDocuments();
     var list = querySnapshot.documents;

     return list;
  }


  Future<DocumentSnapshot> getUserById(String id) async {
    var user = await _fireStore.collection("users").document(id).get();
    return user;
  }

  Future<void> updateUser(String id, String name) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"name": name});
  }

  Future<void> updateImagePath(String id, String path) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"path": path});
  }
}

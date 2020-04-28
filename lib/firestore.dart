import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctsefamilyapp/models/we_family_user.dart';

abstract class BaseStore {
  Future<DocumentSnapshot> getUserById(String id);

  Future<List<DocumentSnapshot>> getAllUsers();
  Future deleteUser(String uid);

  Future<void> updateUser(String id, String name, String age, String mobile);

  Future<void> updateImagePath(String id, String path);
}

class Store implements BaseStore {
  final Firestore _fireStore = Firestore.instance;

  Future deleteUser(String uid) {
    return _fireStore.collection("users").document(uid).delete();
  }

  Future<List<DocumentSnapshot>> getAllUsers() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    return querySnapshot.documents;
  }

  Future<DocumentSnapshot> getUserById(String id) async {
    var user = await _fireStore.collection("users").document(id).get();
    return user;
  }

  Future<void> updateUser(
      String id, String name, String age, String mobile) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"name": name, "age": age, "mobile": mobile});
  }

  Future<void> updateImagePath(String id, String path) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"path": path});
  }
}

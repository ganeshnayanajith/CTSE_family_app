/*Created by IT17106016-Lokugamage G.N.*/

//import packages
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseStore {
  Future<DocumentSnapshot> getUserById(String id);

  Future<List<DocumentSnapshot>> getAllUsers();
  Future deleteUser(String uid);

  Future<void> updateUser(String id, String name, String age, String mobile);

  Future<void> updateImagePath(String id, String path);
}

class Store implements BaseStore {
  final Firestore _fireStore = Firestore.instance;

  //delete a user in the users collection by uid
  Future deleteUser(String uid) {
    return _fireStore.collection("users").document(uid).delete();
  }

  //get all documents in the users collection
  Future<List<DocumentSnapshot>> getAllUsers() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    return querySnapshot.documents;
  }

  Future<DocumentSnapshot> getUserById(String id) async {
    var user = await _fireStore.collection("users").document(id).get();
    return user;
  }

  //update relevant user document
  Future<void> updateUser(
      String id, String name, String age, String mobile) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"name": name, "age": age, "mobile": mobile});
  }

  //update the path attribute by adding url of the image that is stored in the firebase storage
  Future<void> updateImagePath(String id, String path) async {
    await _fireStore
        .collection("users")
        .document(id)
        .updateData({"path": path});
  }
}

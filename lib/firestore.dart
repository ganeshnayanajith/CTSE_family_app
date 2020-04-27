import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctsefamilyapp/models/we_family_user.dart';

abstract class BaseStore {
  Future<DocumentSnapshot> getUserById(String id);

  Future<List<DocumentSnapshot>> getAllUsers();
  //Future<List<WeFamilyUser>> getAllUsers();

  Future<void> updateUser(String id, String name, String age, String mobile);

  Future<void> updateImagePath(String id, String path);
}

class Store implements BaseStore {
  final Firestore _fireStore = Firestore.instance;

  Future<List<DocumentSnapshot>> getAllUsers() async {
    print("getAllUsers--------");
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").getDocuments();

    return querySnapshot.documents;
  }

  /*Future<List<WeFamilyUser>> getAllUsers() async {
    print("getAllUsers--------");
    List<WeFamilyUser> userList;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    var list = querySnapshot.documents;
    list.forEach((user) {
      WeFamilyUser weFamilyUser = new WeFamilyUser(
          uid: user.data["uid"],
          name: user.data["name"],
          path: user.data["path"]);
    });
    return userList;
  }*/

  /*Future<List<DocumentSnapshot>> getAllUsers() async {
     print("getAllUsers--------");
     QuerySnapshot querySnapshot = await Firestore.instance.collection("users").getDocuments();
     var list = querySnapshot.documents;
     return list;
  }*/

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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctsefamilyapp/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password, String name);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future deleteUser(String id);


  Future<void> resetPassword();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BaseStore store = new Store();

  @override
  Future<void> resetPassword() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return await _firebaseAuth.sendPasswordResetEmail(email: user.email);
  }

  @override
  Future deleteUser(String uid) async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      print("/////////////////////"+uid);
      DocumentSnapshot userData = await store.getUserById(uid);
      print("==============="+user.uid);
      await store.deleteUser(uid); // called from database class
      await user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  @override
  Future<String> signUp(String email, String password, String name) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    await Firestore.instance.collection("users").document(user.uid).setData({
      "uid": user.uid,
      "email": email,
      "name": name,
    });
    print("user created in cloud firestore");
    return user.uid;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

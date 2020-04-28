import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:ctsefamilyapp/models/we_family_user.dart';
import 'package:flutter/material.dart';

class WeFamilyUsersFragment extends StatefulWidget {
  WeFamilyUsersFragment(
      {Key key, this.auth, this.store, this.userId, this.signOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback signOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _WeFamilyUsersFragmentState();
}

class _WeFamilyUsersFragmentState extends State<WeFamilyUsersFragment> {
  List<String> imagePaths = [];
  List<String> names = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: loadUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loadding..."),
              );
            } else {
              return _myListView(context, snapshot);
            }
          }),
    );
  }

  Future loadUsers() async {
    return await widget.store.getAllUsers();
  }

  Widget _myListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 22.0,
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: SizedBox(
                  width: 150.0,
                  height: 150.0,
                  child: snapshot.data[index].data["path"] == "null"
                      ? Image.network(
                          snapshot.data[index].data["path"],
                          fit: BoxFit.fill,
                        )
                      : Image(
                          image: AssetImage('user.png'),
                        ),
                ),
              ),
            ),
            title: Text(snapshot.data[index].data["name"]),
          ),
        );
      },
    );
  }
}

import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
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
    return _myListView(context);
  }

  @override
  void initState() {
    super.initState();
    widget.store.getAllUsers().then((documents) {
      documents.forEach((document) {
        print('users list name ' + document.data["name"].toString());
        print('users list path ' + document.data["path"].toString());
        names.add(document.data["name"].toString());
        document.data["path"] == null
            ? imagePaths.add("null")
            : imagePaths.add(document.data["path"].toString());
      });
    });
  }

  Widget _myListView(BuildContext context) {
    print('////////////////////////////////////////////');
    return ListView.builder(
      itemCount: names.length,
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
                  child: imagePaths[index] != "null"
                      ? Image.network(
                          imagePaths[index],
                          fit: BoxFit.fill,
                        )
                      : Image(
                          image: AssetImage('user.png'),
                        ),
                ),
              ),
            ),
            title: Text(names[index]),
          ),
        );
      },
    );
  }
}

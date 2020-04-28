import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  SettingsFragment({Key key, this.auth, this.store, this.userId, this.signOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback signOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change Password'),
        ),
        ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete account'),
            onTap: () async {
              await widget.auth.deleteUser(widget.userId);
            }),
      ],
    );
  }
}

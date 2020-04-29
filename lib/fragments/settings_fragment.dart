import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          onTap: _showDialogPassword,
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete account'),
          onTap: _showDialog,
        ),
      ],
    );
  }

  void _showDialogPassword() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure ?"),
          content: new Text(
              "Do you really want to change the password ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                widget.auth.changePassword(widget.userId,"passwordnew");
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure ?"),
          content: new Text(
              "Do you really want to delete the account ? This process cannot be undone."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                await widget.auth.deleteUser(widget.userId);
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

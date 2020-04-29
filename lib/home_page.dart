import 'dart:io';

import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/fragments/family_member_fragment.dart';
import 'package:ctsefamilyapp/fragments/profile_fragment.dart';
import 'package:ctsefamilyapp/fragments/settings_fragment.dart';
import 'package:ctsefamilyapp/fragments/we_family_users_fragment.dart';
import 'package:ctsefamilyapp/fragments/welcome_fragment.dart';
import 'package:flutter/material.dart';
import 'package:ctsefamilyapp/widgets/nav_drawer.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.store, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback onSignedOut;
  final String userId;

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Profile", Icons.person),
    new DrawerItem("WeFamily Users", Icons.favorite),
    new DrawerItem("Settings", Icons.settings)
  ];

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  String _email = "";
  String _name = "";
  String _uploadedFileURL;

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new WelcomeFragment(
            userId: widget.userId,
            auth: widget.auth,
            store: widget.store,
            onSignedOut: _signOut);
      case 1:
        return new ProfileFragment(
            userId: widget.userId,
            auth: widget.auth,
            store: widget.store,
            signOut: _signOut);
      case 2:
        return new WeFamilyUsersFragment(
            userId: widget.userId,
            auth: widget.auth,
            store: widget.store,
            signOut: _signOut);
      case 3:
        return new SettingsFragment(
            userId: widget.userId,
            auth: widget.auth,
            store: widget.store,
            signOut: _signOut);
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    super.initState();
    widget.store.getUserById(widget.userId).then((user) {
      setState(() {
        if (user != null) {
          print('current user ' + user.data["email"].toString());
          _email = user.data["email"];
          _name = user.data["name"];
          _uploadedFileURL = user.data["path"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(_name),
              accountEmail: new Text(_email),
              currentAccountPicture: (_uploadedFileURL != null)
                  ? Image.network(
                      _uploadedFileURL,
                      fit: BoxFit.fill,
                    )
                  : Image(
                      image: AssetImage('user.png'),
                    ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text('WeFamily'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

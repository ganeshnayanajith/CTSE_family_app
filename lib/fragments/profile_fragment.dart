import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ProfileFragment extends StatefulWidget {
  ProfileFragment({Key key, this.auth, this.store, this.userId, this.signOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback signOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _nameController;
  String _userId = "";
  String _email = "";
  File _image;
  String _uploadedFileURL;

  _update(String id, String name) async {
    try {
      await widget.store.updateUser(id, name);
    } catch (e) {
      print(e);
    }
  }
  _updateImagePath(String id, String path) async {
    try {
      await widget.store.updateImagePath(id, path);
    } catch (e) {
      print(e);
    }
  }
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
  Future _uploadFile() async {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profileimages/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
        _updateImagePath(widget.userId, fileURL);
      });
      print('File _uploadedFileURL ' + _uploadedFileURL);
  }

  @override
  void initState() {
    super.initState();

    widget.store.getUserById(widget.userId).then((user) {
      print('current user ' + user.data["email"].toString());
      setState(() {
        if (user != null) {
          _userId = user?.data["uid"];
          _email = user?.data["email"];
          _emailController =
              new TextEditingController(text: user?.data["email"].toString());
          _nameController =
              new TextEditingController(text: user.data["name"]?.toString());
        }
        if (user.data["path"] != null) {
          setState(() {
            _uploadedFileURL = user.data["path"];
          });
        }

        print('_userId ' + user?.data["uid"].toString());
        print('_email ' + user?.data["email"].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool editing = false;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("widget.userId " + widget.userId);
          print("_nameController.text " + _nameController.text);
          _uploadFile();
          _update(widget.userId, _nameController.text);

          final snackBar = SnackBar(
            content: Text('Profile Updated'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.blue,
                        child: ClipOval(
                          child: SizedBox(
                            width: 150.0,
                            height: 150.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : (_uploadedFileURL != null)
                                    ? Image.network(
                                        _uploadedFileURL,
                                        fit: BoxFit.fill,
                                      )
                                    : Image(
                                        image: AssetImage('user.png'),
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 90.0, right: 30.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: chooseFile,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    enabled: true,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

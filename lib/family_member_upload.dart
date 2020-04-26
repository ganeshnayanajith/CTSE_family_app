import 'dart:io';
import 'package:ctsefamilyapp/home_page.dart';
import 'package:ctsefamilyapp/home_page_family.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FamilyMemberUpload extends StatefulWidget {
  @override
  _FamilyMemberUploadState createState() => _FamilyMemberUploadState();
}

class _FamilyMemberUploadState extends State<FamilyMemberUpload> {
  String givenName;
  String familyName;
  String birthDate;
  String gender;
  String age;

  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  Future getImageFromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      sampleImage = tempImage;
    });
  }

  showImageSelectDialog() {
    // set up the buttons
    Widget galleryButton = FlatButton(
      child: Text("Select From Gallery"),
      onPressed: getImage,
    );
    Widget cameraButton = FlatButton(
      child: Text("Select From Camera"),
      onPressed: getImageFromCamera,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Add Your Family Member"),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImageFamily() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Family Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image URL = " + url);

      goToHomePage();

      saveToDatabaseFamily(url);
    }
  }

  void saveToDatabaseFamily(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var memberData = {
      "image": url,
      "givenName": givenName,
      "familyName": familyName,
      "birthDate": birthDate,
      "gender": gender,
      "age": age,
      "date": date,
      "time": time
    };

    ref.child("FamilyMembers").push().set(memberData);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new HomePageFamily();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showImageSelectDialog,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 310.0,
                width: 600.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Given Name',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Enter Description' : null;
                },
                onSaved: (value) {
                  return givenName = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Family Name',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Enter Description' : null;
                },
                onSaved: (value) {
                  return familyName = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Birth Day',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Enter Description' : null;
                },
                onSaved: (value) {
                  return birthDate = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Enter Age' : null;
                },
                onSaved: (value) {
                  return age = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              DropdownButton(
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  gender = "Male";
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                child: Text('Add Member'),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: uploadStatusImageFamily,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

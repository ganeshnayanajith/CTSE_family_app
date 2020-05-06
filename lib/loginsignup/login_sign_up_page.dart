/*
* Created by IT17106016-Lokugamage G.N.
* Implementation of login and sign up page
* This is a reference of https://www.javacodegeeks.com/2019/09/flutter-firebase-authentication-tutorial.html
* */

//import packages
import 'package:flutter/material.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';

import 'authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  String _errorMessage = "";

  // this will be used to identify the form to show
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("WeFamily"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                logo(),
                SizedBox(
                  height: 10.0,
                ),
                _formMode == FormMode.LOGIN
                    ? formWidgetLogin()
                    : formWidgetSignUp(),
                progressWidget(),
                errorWidget(),
                loginButtonWidget(),
                secondaryButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('assets/family.jpg'),
      ),
    );
  }

  Widget progressWidget() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget formWidgetSignUp() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _nameWidget(),
          _emailWidget(),
          _passwordWidget(),
        ],
      ),
    );
  }

  Widget formWidgetLogin() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _emailWidget(),
          _passwordWidget(),
        ],
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Enter Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _nameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Enter Full Name',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? 'Full name cannot be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget _passwordWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget loginButtonWidget() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new MaterialButton(
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.pink,
        child: _formMode == FormMode.LOGIN
            ? new Text(
                'Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white),
              )
            : new Text(
                'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white),
              ),
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget secondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text(
              'Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
            )
          : new Text(
              'Have an account? Sign in',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
            ),
      onPressed: _formMode == FormMode.LOGIN ? showSignUpForm : showLoginForm,
    );
  }

  void showSignUpForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void showLoginForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  Widget errorWidget() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
        } else {
          userId = await widget.auth.signUp(_email, _password, _name);
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

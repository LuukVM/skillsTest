import 'package:flutter/material.dart';
import 'package:test_imports/inherited_widget.dart';
import 'package:test_imports/screens/login/sign_in_screen.dart';
import 'package:test_imports/screens/home_screen.dart';
import 'package:test_imports/services/auth.dart';
import 'package:test_imports/services/shared_preferences.dart';
import 'package:location/location.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthService _auth = AuthService();

  bool _isLoggedin = false;
  Location _location = Location();
  PermissionStatus _permissionStatus;
  String _email, _password;
  var result;

  @override
  void initState() {
    super.initState();
    askLocationPermission();
    checkUserLoggedInStatus();
  }

  Future askLocationPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future checkUserLoggedInStatus() async {
    await SharedPreferencesUser.getUserLoggedInSharedPreference().then((value) {
      if (value ?? false) {
        getUserInfo();
      }
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  getUserInfo() async {
    await SharedPreferencesUser.getUserEmailSharedPreference().then((value) {
      _email = value;
    });

    await SharedPreferencesUser.getUserPasswordSharedPreference().then((value) {
      _password = value;
    });

    result = await _auth.signInWithEmailAndPassword(_email, _password);
    setState(() {});
  }

  logIn() {
    if (result != null) {
      return InheritedDataGetter(child: Home(), user: result);
    } else {
      return SignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (_isLoggedin ?? false) ? logIn() : SignIn(),
    );
  }
}

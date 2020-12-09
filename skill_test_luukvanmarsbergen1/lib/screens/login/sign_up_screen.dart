import 'package:flutter/material.dart';
import 'package:test_imports/inherited_widget.dart';
import 'package:test_imports/services/auth.dart';
import 'package:test_imports/screens/home_screen.dart';
import 'package:test_imports/models/user_model.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool _isLoading = false;
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Registreer een account"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 12),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Vul uw email in"),
                  obscureText: false,
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: "Vul uw wachtwoord in"),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Automatisch inloggen"),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.grey,
                      ),
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: _onRememberMeChanged,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 18),
                Container(
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FlatButton(
                          child: Text(
                            'Registeer en log in',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () => _signUp(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signUp() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      UserModel result = await _auth.signUpWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (result != null) {
        await _auth.saveUserDetailsOnLogin(
            result, _passwordController.text, rememberMe);
        Navigator.of(context).pop();
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InheritedDataGetter(
              user: result,
              child: Home(),
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _key.currentState.showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.red,
              content: Container(
                alignment: Alignment.center,
                height: 25,
                child: Text(
                  "Er is iets mis gegaan probeer het nog eens",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          );
        });
      }
    } else {
      _key.currentState.showSnackBar(
        SnackBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red,
          content: Container(
            alignment: Alignment.center,
            height: 25,
            child: Text(
              "Vul geldige waardes in",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      );
    }
  }
}

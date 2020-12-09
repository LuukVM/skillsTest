import 'package:flutter/material.dart';
import 'package:test_imports/inherited_widget.dart';
import 'package:test_imports/services/auth.dart';
import 'package:test_imports/screens/home_screen.dart';
import 'package:test_imports/screens/login/sign_up_screen.dart';
import 'package:test_imports/models/user_model.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool _isLoading = false;
  bool rememberMe = false;

  final _key = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      body: Center(
        child: Form(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    "Log in met uw account",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                    Text("Onthoud mij"),
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
                            'Log in',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () => signIn(),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: FlatButton(
                    child: Text('Geen account? Registreer hier'),
                    onPressed: () => _toSignUp(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      UserModel result = await _auth.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (result != null) {
        if (result != null) {
          _auth.saveUserDetailsOnLogin(
              result, _passwordController.text, rememberMe);
        }
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => InheritedDataGetter(
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

  _toSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignUp(),
      ),
    );
  }
}

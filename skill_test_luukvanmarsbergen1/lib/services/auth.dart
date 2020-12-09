import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_imports/models/user_model.dart';
import 'package:test_imports/screens/login/sign_in_screen.dart';
import 'package:test_imports/services/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(id: user.uid, email: user.email) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      await SharedPreferencesUser.saveUserLoggedInSharedPreference(false);
      await SharedPreferencesUser.removeUserEmailSharedPreference();
      await SharedPreferencesUser.removeUserPasswordSharedPreference();

      // await Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => SignIn()));

      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));

      return await _auth.signOut();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }

  saveUserDetailsOnLogin(
      UserModel user, String password, bool rememberMe) async {
        
    await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(user.id)
        .doc('restaurant')
        .collection('marker')
        .doc('favorite')
        .set({
      'id': FieldValue.arrayUnion(['']),
    });

    await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(user.id)
        .doc('hotel')
        .collection('marker')
        .doc('favorite')
        .set({
      'id': FieldValue.arrayUnion(['']),
    });

    await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(user.id)
        .doc('bar')
        .collection('marker')
        .doc('favorite')
        .set({
      'id': FieldValue.arrayUnion(['']),
    });

    if (rememberMe) {
      await SharedPreferencesUser.saveUserLoggedInSharedPreference(rememberMe);

      await SharedPreferencesUser.saveUserEmailSharedPreference(user.email);
      await SharedPreferencesUser.saveUserPasswordSharedPreference(password);
    }
  }
}

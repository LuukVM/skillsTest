import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUser{

  static const String sharedPreferenceUserLoggedInKey = "USERLOGGEDINKEY";
  static const String sharedPreferenceUserPassKey = "USERPASSKEY";
  static const String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //Save Users
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<void> saveUserPasswordSharedPreference(String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserPassKey, pass);
  }


  //Read Users
 static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserPassKey);
  }


  //Remove Users
  static Future<void> removeUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserEmailKey);
  }

  static Future<void> removeUserPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserPassKey);
  }

}
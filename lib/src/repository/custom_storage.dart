
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomStorage extends CognitoStorage {
  // Obtain shared preferences.
  late SharedPreferences prefs;

  CustomStorage() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> clear() {
    return prefs.clear();
  }

  @override
  Future<String?> getItem(String key) {
    return Future.value(prefs.getString(key));
  }

  @override
  Future removeItem(String key) {
    return prefs.remove(key);
  }

  @override
  Future setItem(String key, value) {
    return prefs.setString(key, value);
  }
  
}
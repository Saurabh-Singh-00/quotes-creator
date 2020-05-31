import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  String username = "Anonymous";

  Future<bool> authenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool auth = sharedPreferences.getBool("isAuthenticated");
    if (auth == null) {
      return false;
    }
    username = sharedPreferences.get("username");
    return auth;
  }

  Future saveAuthPreference(Map<String, dynamic> authPreference) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "isAuthenticated", authPreference["isAuthenticated"]);
    sharedPreferences.setString("username", authPreference["username"]);
    username = authPreference["username"];
  }
}

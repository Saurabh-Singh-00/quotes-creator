import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  String username = "Anonymous";
  String avatar = "assets/avatar/avatar (1).png";

  Future<bool> authenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool auth = sharedPreferences.getBool("isAuthenticated");
    if (auth == null) {
      return false;
    }
    avatar = sharedPreferences.get("avatar");
    username = sharedPreferences.get("username");
    return auth;
  }

  Future saveAuthPreference(Map<String, dynamic> authPreference) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "isAuthenticated", authPreference["isAuthenticated"]);
    sharedPreferences.setString("username", authPreference["username"]);
    sharedPreferences.setString("avatar", authPreference["avatar"]);
    username = authPreference["username"];
    avatar = authPreference["avatar"];
  }
}

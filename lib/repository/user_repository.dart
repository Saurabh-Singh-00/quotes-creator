import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<bool> authenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool auth = sharedPreferences.getBool("isAuthenticated");
    if (auth == null) {
      return false;
    }
    return auth;
  }
}

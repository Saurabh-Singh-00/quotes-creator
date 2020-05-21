import 'package:insta_creator/secrets/_key.dart';

class Keys {
  /// Create a file [_key.dart] in secrets(this) directory and paste the code below
  /// [String pexelAuthKey = "YOUR_API_KEY";]
  /// Replace ["YOUR_API_KEY"] with your obtained Key
  static final String _pexelKey = pexelAuthKey;

  static String get pexelKey => _pexelKey;
}

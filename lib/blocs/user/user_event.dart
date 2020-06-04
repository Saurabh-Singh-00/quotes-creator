abstract class UserEvent {}

class AuthenticateUser extends UserEvent {}

class SaveUserPreference extends UserEvent {
  final String username;
  final String avatar;

  SaveUserPreference({this.username, this.avatar});
}

class ChangeProfilePhoto extends UserEvent {
  final String profilePicPath;

  ChangeProfilePhoto(this.profilePicPath);
}

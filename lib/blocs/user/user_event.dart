abstract class UserEvent {}

class AuthenticateUser extends UserEvent {}

class SaveUserPreference extends UserEvent {
  final String username;

  SaveUserPreference({this.username});
}

class ChangeProfilePhoto extends UserEvent {
  final String profilePicPath;

  ChangeProfilePhoto(this.profilePicPath);
}

abstract class UserEvent {}

class AuthenticateUser extends UserEvent {}

class ChangeProfilePhoto extends UserEvent {
  final String profilePicPath;

  ChangeProfilePhoto(this.profilePicPath);
}

abstract class UserState {}

class AuthenticationUninitialized extends UserState {}

class AuthenticatedUser extends UserState {}

class AuthenticatingUser extends UserState {}

class SavingUserPreference extends UserState {}

class UnauthenticatedUser extends UserState {}

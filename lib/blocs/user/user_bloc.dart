import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/user/user_event.dart';
import 'package:insta_creator/blocs/user/user_state.dart';
import 'package:insta_creator/repository/user_repository.dart';

export './user_event.dart';
export './user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository = UserRepository();

  @override
  UserState get initialState => AuthenticationUninitialized();

  Stream<UserState> _mapAuthenticateUserToState() async* {
    yield AuthenticatingUser();
    bool auth = await repository.authenticate();
    if (auth) {
      yield AuthenticatedUser();
    } else {
      yield UnauthenticatedUser();
    }
  }

  Stream<UserState> _mapSaveUserPreferenceToState(
      SaveUserPreference event) async* {
    yield SavingUserPreference();
    await repository.saveAuthPreference(
        {"isAuthenticated": true, "username": event.username});
    yield AuthenticatedUser();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is AuthenticateUser) {
      yield* _mapAuthenticateUserToState();
    }
    if (event is SaveUserPreference) {
      yield* _mapSaveUserPreferenceToState(event);
    }
  }
}

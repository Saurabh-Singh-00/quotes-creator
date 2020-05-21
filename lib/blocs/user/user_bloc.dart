import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/user/user_event.dart';
import 'package:insta_creator/blocs/user/user_state.dart';
import 'package:insta_creator/repository/user_repository.dart';

export './user_event.dart';
export './user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository = UserRepository();

  @override
  UserState get initialState => AuthenticatedUser();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {}
}

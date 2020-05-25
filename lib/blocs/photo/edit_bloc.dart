import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_event.dart';
import 'package:insta_creator/blocs/photo/edit_state.dart';
import 'package:insta_creator/models/photo.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final Photo background;

  EditBloc({this.background});

  @override
  EditState get initialState => EditUninitialized(photo: this.background);

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    dynamic currentState = state;
    if (event is AddQuote) {
      if (currentState is EditUninitialized) {
        yield Editing(quotes: [event.toJson()]);
        return;
      }
      if (currentState is Editing) {
        yield Editing.copyWith(quotes: currentState.quotes + [event.toJson()]);
      }
    }
  }
}

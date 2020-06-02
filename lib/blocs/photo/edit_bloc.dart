import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_event.dart';
import 'package:insta_creator/blocs/photo/edit_state.dart';
import 'package:insta_creator/models/photo.dart';

export 'package:insta_creator/blocs/photo/edit_state.dart';
export 'package:insta_creator/blocs/photo/edit_event.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final Photo background;
  final StreamController<bool> savingStream =
      StreamController<bool>.broadcast();
  final List<EditState> editStates = List<EditState>();

  Future close() async {
    savingStream.close();
    super.close();
  }

  EditBloc({this.background});

  @override
  EditState get initialState => EditUninitialized(photo: this.background);

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    dynamic currentState = state;
    if (event is AddQuote) {
      if (event.quote.text == null || event.quote.text.isEmpty) {
        yield currentState;
        return;
      }
      if (currentState is EditUninitialized) {
        yield Editing(quotes: [event.quote]);
        return;
      }
      if (currentState is Editing) {
        yield Editing.copyWith(quotes: currentState.quotes + [event.quote]);
      }
      if (currentState is SaveComplete) {
        dynamic savedState = editStates.removeLast();
        if (savedState is EditUninitialized) {
          yield Editing(quotes: [event.quote]);
          return;
        } else if (savedState is Editing) {
          yield Editing.copyWith(quotes: savedState.quotes + [event.quote]);
        }
      }
    }
    if (event is DeleteQuote) {
      if (currentState is Editing) {
        currentState.quotes.remove(event.quote);
        yield Editing.copyWith(quotes: currentState.quotes);
      }
    }
    if (event is Save) {
      savingStream.sink.add(true);
    }
    if (event is Saved) {
      if (currentState is Editing || currentState is EditUninitialized) {
        editStates.add(currentState);
      }
      savingStream.sink.add(false);
      yield SaveComplete();
    }
  }
}

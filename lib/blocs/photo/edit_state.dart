import 'package:insta_creator/models/photo.dart';

abstract class EditState {}

class EditUninitialized extends EditState {
  final Photo photo;

  EditUninitialized({this.photo});
}

class Saved extends EditState {}

class Editing extends EditState {
  final List<Map> quotes;

  Editing({this.quotes});

  Editing.copyWith({List<Map> quotes}) : this.quotes = quotes;
}

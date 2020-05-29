import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/models/quote.dart';

abstract class EditState {
  List<Quote> quotes;
}

class EditUninitialized extends EditState {
  final Photo photo;

  EditUninitialized({this.photo});
}

class Editing extends EditState {
  final List<Quote> quotes;

  Editing({this.quotes});

  Editing.copyWith({List<Quote> quotes}) : this.quotes = quotes;
}

class SaveComplete extends EditState {}

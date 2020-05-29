import 'package:insta_creator/models/quote.dart';

abstract class EditEvent {}

class AddQuote extends EditEvent {
  final Quote quote;

  AddQuote({this.quote});

  AddQuote.copyWith({this.quote});
}

class Save extends EditEvent {}

class Saved extends EditEvent {}

class DeleteQuote extends EditEvent {
  final Object quote;

  DeleteQuote(this.quote);
}

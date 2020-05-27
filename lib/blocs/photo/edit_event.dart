import 'package:flutter/material.dart';

abstract class EditEvent {}

class AddQuote extends EditEvent {
  final String quote;
  Color color = Colors.white;
  double fontSize = 16.0;
  TextAlign align = TextAlign.left;
  String fontFamily = "Anton";

  AddQuote(
      {this.color, this.fontSize, this.quote, this.align, this.fontFamily});

  AddQuote.copyWith(
      {this.quote, this.color, this.fontSize, this.align, this.fontFamily});

  Map toJson() {
    return {
      "quote": this.quote,
      "color": this.color,
      "fontSize": this.fontSize,
      "align": this.align,
      "fontFamily": this.fontFamily,
    };
  }
}

class Save extends EditEvent {}

class Saved extends EditEvent {}

class DeleteQuote extends EditEvent {
  final Object quote;

  DeleteQuote(this.quote);
}

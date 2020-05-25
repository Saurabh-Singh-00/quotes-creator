import 'package:flutter/material.dart';

abstract class EditEvent {}

class AddQuote extends EditEvent {
  final String quote;
  Color color = Colors.white;
  double fontSize = 16.0;

  AddQuote({this.color, this.fontSize, this.quote});

  AddQuote.copyWith({this.quote, this.color, this.fontSize});

  Map toJson() {
    return {
      "quote": this.quote,
      "color": this.color,
      "fontSize": this.fontSize,
    };
  }
}

import 'package:flutter/rendering.dart';

extension ColorExtension on String {
  Color toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    if (hexColor.length == 10) {
      return Color(int.parse("$hexColor"));
    }
    return Color(0XFFFFFFFF);
  }
}

extension TextAlignmentExtension on String {
  static Map<String, TextAlign> alignment = {
    "TextAlign.left": TextAlign.left,
    "TextAlign.right": TextAlign.right,
    "TextAlign.center": TextAlign.center
  };
  TextAlign toTextAlignment() {
    if (this == "" || this == null) {
      return TextAlign.left;
    }
    return alignment[this];
  }
}

class Quote {
  String text;
  String color;
  double fontSize;
  String fontFamily;
  String textAlign;
  double xCord = 0.0;
  double yCord = 0.0;

  Quote(
      {this.text,
      this.color,
      this.fontSize,
      this.fontFamily,
      this.textAlign,
      this.xCord,
      this.yCord});

  Quote.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    color = json['color'];
    fontSize = json['fontSize'];
    fontFamily = json['fontFamily'];
    textAlign = json['textAlign'];
    xCord = json['xCord'];
    yCord = json['yCord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['color'] = this.color;
    data['fontSize'] = this.fontSize;
    data['fontFamily'] = this.fontFamily;
    data['textAlign'] = this.textAlign;
    data['xCord'] = this.xCord;
    data['yCord'] = this.yCord;
    return data;
  }
}

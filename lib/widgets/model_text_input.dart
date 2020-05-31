import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_creator/blocs/photo/edit_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_event.dart';
import 'package:insta_creator/models/quote.dart';

class ModalTextInput extends StatefulWidget {
  final EditBloc bloc;
  final Quote quote;
  final bool isEdit;

  const ModalTextInput({Key key, this.bloc, this.quote, this.isEdit})
      : super(key: key);

  @override
  _ModalTextInputState createState() => _ModalTextInputState();
}

class _ModalTextInputState extends State<ModalTextInput> {
  Color textColor = Colors.white;
  double fontSize = 16.0;
  TextEditingController tec;
  TextAlign textAlign = TextAlign.left;
  FontWeight fontWeight;

  List<String> fontFamilies = [
    "Anton",
    "Lobster",
    "DM Mono",
    "Permanent Marker",
    "Piedra",
    "Pacifico"
  ];

  List<TextAlign> alignOptions = [
    TextAlign.left,
    TextAlign.center,
    TextAlign.right
  ];

  int alignmentIndex = 0;
  int fontIndex = 0;
  String fontFamily = "Anton";

  @override
  void initState() {
    tec = TextEditingController();
    if (widget.quote != null) {
      tec.text = widget.quote.text;
      textColor = widget.quote.color.toColor();
      fontSize = widget.quote.fontSize;
      textAlign = widget.quote.textAlign.toTextAlignment();
      fontFamily = widget.quote.fontFamily;
    }
    super.initState();
  }

  void changeColor() {
    setState(() {
      textColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
  }

  void changeFont() {
    setState(() {
      fontFamily = fontFamilies[++fontIndex % fontFamilies.length];
    });
  }

  void changeAlignment() {
    setState(() {
      textAlign = alignOptions[++alignmentIndex % alignOptions.length];
    });
  }

  void increaseFontSize() {
    setState(() {
      fontSize += 2;
    });
  }

  void decreaseFontSize() {
    if (fontSize < 8) return;
    setState(() {
      fontSize -= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: TextFormField(
                    controller: tec,
                    cursorColor: textColor,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    textAlign: textAlign,
                    autofocus: true,
                    scrollPhysics: BouncingScrollPhysics(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontFamily: fontFamily,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Your Quote Here!",
                      hintStyle: TextStyle(
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              height: 56.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.color_lens,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        changeColor();
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        increaseFontSize();
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        decreaseFontSize();
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.format_align_left,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        changeAlignment();
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.font_download,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        changeFont();
                      }),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: FloatingActionButton(
            child: Icon(
              Icons.done_all,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              if (widget.isEdit) {
                setState(() {
                  widget.quote.text = tec.value.text;
                  widget.quote.fontSize = fontSize;
                  widget.quote.color = textColor.value.toString();
                  widget.quote.textAlign = textAlign.toString();
                  widget.quote.fontFamily = fontFamily;
                });
              } else {
                widget.bloc.add(
                  AddQuote(
                    quote: Quote(
                      text: tec.value.text,
                      color: textColor.value.toString(),
                      fontSize: fontSize,
                      fontFamily: fontFamily,
                      textAlign: textAlign.toString(),
                      xCord: 0.0,
                      yCord: 0.0,
                    ),
                  ),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

//

//

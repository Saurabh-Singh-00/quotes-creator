import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_creator/blocs/photo/edit_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_event.dart';

class ModalTextInput extends StatefulWidget {
  final EditBloc bloc;
  final Map quote;
  final bool isEdit;

  const ModalTextInput({Key key, this.bloc, this.quote, this.isEdit})
      : super(key: key);

  @override
  _ModalTextInputState createState() => _ModalTextInputState();
}

class _ModalTextInputState extends State<ModalTextInput> {
  Color textColor = Colors.black;
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
      tec.text = widget.quote['quote'];
      textColor = widget.quote['color'] == Colors.white
          ? Colors.black
          : widget.quote['color'];
      fontSize = widget.quote['fontSize'];
      textAlign = widget.quote['align'];
      fontFamily = widget.quote['fontFamily'];
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: .0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // TextField
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFormField(
                    controller: tec,
                    cursorColor: textColor,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    textAlign: textAlign,
                    scrollPhysics: BouncingScrollPhysics(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Your Quote Here!",
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.color_lens),
                    onPressed: () {
                      changeColor();
                    }),
                IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      increaseFontSize();
                    }),
                IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      decreaseFontSize();
                    }),
                IconButton(
                    icon: Icon(Icons.format_align_left),
                    onPressed: () {
                      changeAlignment();
                    }),
                IconButton(
                    icon: Icon(Icons.font_download),
                    onPressed: () {
                      changeFont();
                    }),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: FloatingActionButton(
            child: Icon(
              Icons.done_all,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              if (widget.isEdit) {
                setState(() {
                  widget.quote['quote'] = tec.value.text;
                  widget.quote['fontSize'] = fontSize;
                  widget.quote['color'] =
                      textColor == Colors.black ? Colors.white : textColor;
                  widget.quote['align'] = textAlign;
                  widget.quote['fontFamily'] = fontFamily;
                });
              } else {
                widget.bloc.add(AddQuote(
                  quote: tec.value.text,
                  fontSize: fontSize,
                  color: textColor == Colors.black ? Colors.white : textColor,
                  align: textAlign,
                  fontFamily: fontFamily,
                ));
              }

              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

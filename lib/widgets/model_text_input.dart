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
  List<TextAlign> alignOptions = [
    TextAlign.left,
    TextAlign.center,
    TextAlign.right
  ];
  int alignmentIndex = 0;

  @override
  void initState() {
    tec = TextEditingController();
    if (widget.quote != null) {
      tec.text = widget.quote['quote'];
      textColor = widget.quote['color'];
      fontSize = widget.quote['fontSize'];
      textAlign = widget.quote['align'];
    }
    super.initState();
  }

  void changeColor() {
    setState(() {
      textColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
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
        backgroundColor: Colors.grey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Formating Options
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
              ],
            ),
            // TextField
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: tec,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  textAlign: textAlign,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your Quote Here!",
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
                widget.quote['color'] = textColor;
                widget.quote['align'] = textAlign;
              });
            } else {
              widget.bloc.add(AddQuote(
                quote: tec.value.text,
                fontSize: fontSize,
                color: Colors.white,
                align: textAlign,
              ));
            }

            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

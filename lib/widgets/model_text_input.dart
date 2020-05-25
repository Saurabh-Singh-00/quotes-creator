import 'package:flutter/material.dart';
import 'package:insta_creator/blocs/photo/edit_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_event.dart';

class ModalTextInput extends StatefulWidget {
  final EditBloc bloc;
  final Map quote;

  const ModalTextInput({Key key, this.bloc, this.quote}) : super(key: key);

  @override
  _ModalTextInputState createState() => _ModalTextInputState();
}

class _ModalTextInputState extends State<ModalTextInput> {
  Color textColor = Colors.black;
  double fontSize = 16.0;
  TextEditingController tec;

  @override
  void initState() {
    tec = TextEditingController();
    if (widget.quote != null) {
      tec.text = widget.quote['quote'];
      textColor = widget.quote['color'];
      fontSize = widget.quote['fontSize'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Formating Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(icon: Icon(Icons.color_lens), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.format_align_left), onPressed: () {}),
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
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your Quote Here!",
                  ),
                ),
              ),
            ),
            // Save/Discard
            RaisedButton(
              onPressed: () {
                widget.bloc.add(AddQuote(
                  quote: tec.value.text,
                  color: Colors.white,
                ));
                Navigator.of(context).pop();
              },
              color: Colors.black,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

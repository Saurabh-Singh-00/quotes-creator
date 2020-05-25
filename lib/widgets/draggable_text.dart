import 'package:flutter/material.dart';

class DraggableQuote extends StatefulWidget {
  final Map quote;
  final Function onTap;

  const DraggableQuote({Key key, this.quote, this.onTap}) : super(key: key);
  @override
  _DraggableQuoteState createState() => _DraggableQuoteState();
}

class _DraggableQuoteState extends State<DraggableQuote> {
  double xCord = 0.0;
  double yCord = 0.0;
  double fontSize, initialFontSize;

  @override
  void initState() {
    initialFontSize = widget.quote['fontSize'];
    fontSize = initialFontSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yCord,
      left: xCord,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails dragDetails) {
          setState(() {
            xCord += dragDetails.delta.dx;
            yCord += dragDetails.delta.dy;
          });
        },
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Text(
              "${widget.quote['quote']}",
              textAlign: TextAlign.center,
              maxLines: 99,
              style: TextStyle(
                color: widget.quote['color'],
                // fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

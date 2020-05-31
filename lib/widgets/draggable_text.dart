import 'package:flutter/material.dart';
import 'package:insta_creator/models/quote.dart';

class DraggableQuote extends StatefulWidget {
  final Quote quote;
  final Function onDelete;
  final Function onEdit;

  const DraggableQuote({Key key, this.quote, this.onDelete, this.onEdit})
      : super(key: key);
  @override
  _DraggableQuoteState createState() => _DraggableQuoteState();
}

class _DraggableQuoteState extends State<DraggableQuote> {
  double xCord = 0.0;
  double yCord = 0.0;
  bool optionsVisible = false;

  @override
  void initState() {
    xCord = widget.quote.xCord;
    yCord = widget.quote.yCord;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.quote.yCord,
      left: widget.quote.xCord,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails dragDetails) {
          setState(() {
            widget.quote.xCord += dragDetails.delta.dx;
            widget.quote.yCord += dragDetails.delta.dy;
          });
        },
        onTap: () {
          setState(() {
            optionsVisible = !optionsVisible;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                optionsVisible
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Tap on text to toggle options",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                              onPressed: widget.onDelete),
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: widget.onEdit),
                        ],
                      )
                    : Container(),
                Text(
                  "${widget.quote.text}",
                  textAlign: widget.quote.textAlign.toTextAlignment(),
                  maxLines: 99,
                  style: TextStyle(
                    color: widget.quote.color.toColor(),
                    fontSize: widget.quote.fontSize,
                    fontFamily: widget.quote.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

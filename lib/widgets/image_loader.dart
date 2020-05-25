import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final Widget child;
  final ImageChunkEvent loadingProgress;

  const ImageLoader({Key key, this.loadingProgress, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (loadingProgress == null) return child;
    double progressValue = loadingProgress.cumulativeBytesLoaded /
        loadingProgress.expectedTotalBytes;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Loading Full Resolution Image",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          LinearProgressIndicator(
            backgroundColor: Colors.white,
            value: progressValue,
            valueColor: AlwaysStoppedAnimation(
              ColorTween(begin: Colors.red[300], end: Colors.green)
                  .transform(progressValue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${(progressValue * 100).round()} %",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

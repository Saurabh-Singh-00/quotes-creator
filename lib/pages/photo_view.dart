import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_creator/widgets/image_loader.dart';

class PhotoView extends StatelessWidget {
  final String path;

  const PhotoView({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: .0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Image(
            image: FileImage(File(path)),
            fit: BoxFit.fitWidth,
            errorBuilder: (_, e, trace) {
              return Center(
                child: Text(
                  "Oops! Error reading image",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
            loadingBuilder: (_, child, progress) {
              return ImageLoader(
                child: child,
                loadingProgress: progress,
              );
            },
          ),
        ),
      ),
    );
  }
}

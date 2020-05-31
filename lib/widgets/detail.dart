import 'package:flutter/material.dart';
import 'package:insta_creator/models/photo.dart';

class Detail extends StatelessWidget {
  final Photo photo;
  const Detail({
    Key key,
    this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
            child: Text(
              "Photo Details",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    photo.photographer,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.link,
                      color: Colors.blue,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }
}

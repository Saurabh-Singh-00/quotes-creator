import 'package:flutter/material.dart';
import 'package:insta_creator/widgets/photo_grid.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: MediaQuery.of(context).size.width * 0.15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "@Saurabh Singh",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          PhotoGrid(
            photos: [],
            scrollController: scrollController,
            hasReachedMax: true,
            storageKey: '__profile_page_key__',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/widgets/photo_card.dart';

class GridLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<Photo> photos;
  final bool hasReachedMax;
  final String storageKey;

  const PhotoGrid(
      {Key key,
      this.scrollController,
      this.photos,
      this.hasReachedMax,
      this.storageKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        key: PageStorageKey('$storageKey'),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        itemCount: hasReachedMax ? photos.length : photos.length + 1,
        itemBuilder: (context, index) {
          return index >= photos.length
              ? GridLoader()
              : PhotoCard(
                  photo: photos[index],
                );
        },
        staggeredTileBuilder: (index) {
          return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
        });
  }
}

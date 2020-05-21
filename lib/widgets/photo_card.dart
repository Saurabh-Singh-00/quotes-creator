import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/pages/photo_detail.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;

  const PhotoCard({Key key, this.photo}) : super(key: key);

  Widget loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent progress) {
    if (progress == null) return child;
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void onTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoDetailPage(
          photo: photo,
        ),
      ),
    );
  }

  void onDoubleTap(BuildContext context) {
    BlocProvider.of<PhotoBloc>(context)
      ..add(
        LikePhoto(photo),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: InkWell(
                onDoubleTap: () => onDoubleTap(context),
                onTap: () => onTap(context),
                child: Image.network(
                  photo.src.medium,
                  fit: BoxFit.cover,
                  loadingBuilder: loadingBuilder,
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: CircleAvatar(
                backgroundColor: Colors.white54,
                child: InkWell(
                  onTap: () => onDoubleTap(context),
                  child: StreamBuilder(
                    initialData: photo,
                    stream:
                        BlocProvider.of<PhotoBloc>(context).likedPhotos$.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<Photo> snapshot) {
                      if (snapshot.data.id == photo.id) {
                        this.photo.isLiked = snapshot.data.isLiked;
                      }
                      return Icon(
                        photo.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: photo.isLiked ? Colors.red : Colors.black,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

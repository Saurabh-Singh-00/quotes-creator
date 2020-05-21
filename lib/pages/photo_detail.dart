import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/models/photo.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  PhotoDetailPage({Key key, this.photo}) : super(key: key);

  final Map<String, Map<String, dynamic>> navbarItems = {
    "Details": {
      "icon": Icons.info_outline,
      "callback": (BuildContext context) {},
    },
    "Favourite": {
      "icon": Icons.favorite_border,
      "callback": (BuildContext context, Photo p) {
        BlocProvider.of<PhotoBloc>(context).add(LikePhoto(p));
      },
    },
    "Edit": {
      "icon": Icons.mode_edit,
      "callback": (BuildContext context) {},
    },
    "Share": {
      "icon": Icons.share,
      "callback": (BuildContext context) {},
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: .0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          photo.src.original,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  photo.src.medium,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            (navbarItems.entries.toList()[index].value["callback"] as Function)(
                context, photo);
          } else {
            (navbarItems.entries.toList()[index].value["callback"]
                as Function)(context);
          }
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: .0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: navbarItems.entries.map((element) {
          return BottomNavigationBarItem(
            icon: element.key == "Favourite"
                ? StreamBuilder<Photo>(
                    initialData: photo,
                    stream:
                        BlocProvider.of<PhotoBloc>(context).likedPhotos$.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data.id == photo.id) {
                        this.photo.isLiked = snapshot.data.isLiked;
                      }
                      return photo.isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border);
                    },
                  )
                : Icon(element.value["icon"]),
            title: Text(element.key),
          );
        }).toList(),
      ),
    );
  }
}

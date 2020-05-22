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
    },
    "Save": {
      "icon": Icons.save_alt,
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
          fit: BoxFit.fill,
          loadingBuilder: loadingBuilder,
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          bottomAppBarColor: Colors.black,
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) {
              (navbarItems.entries.toList()[index].value["callback"]
                  as Function)(context, photo);
            } else {
              (navbarItems.entries.toList()[index].value["callback"]
                  as Function)(context);
            }
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: .0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: navbarItems.entries.map((element) {
            return BottomNavigationBarItem(
              icon: element.key == "Favourite"
                  ? StreamBuilder<Photo>(
                      initialData: photo,
                      stream: BlocProvider.of<PhotoBloc>(context)
                          .likedPhotos$
                          .stream,
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
      ),
    );
  }

  Widget loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
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

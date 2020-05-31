import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/pages/photo_edit.dart';
import 'package:insta_creator/widgets/detail.dart';
import 'package:insta_creator/widgets/image_loader.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  PhotoDetailPage({Key key, this.photo}) : super(key: key);

  final Map<String, Map<String, dynamic>> navbarItems = {
    "Details": {
      "icon": Icons.info_outline,
      "callback": (BuildContext context, Photo p) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Detail(photo: p);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          )),
        );
      },
    },
    "Favourite": {
      "icon": Icons.favorite_border,
      "callback": (BuildContext context, Photo p) {
        BlocProvider.of<PhotoBloc>(context).add(LikePhoto(p));
      },
    },
    "Edit": {
      "icon": Icons.mode_edit,
      "callback": (BuildContext context, Photo p) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoEditPage(
              photo: p,
            ),
          ),
        );
      },
    },
    "Share": {
      "icon": Icons.share,
      "callback": (BuildContext context, Photo p) {},
    },
    "Save": {
      "icon": Icons.save_alt,
      "callback": (BuildContext context, Photo p) {},
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
          photo.src != null ? photo.src.original : photo.srcFromDbOriginal,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) => ImageLoader(
            child: child,
            loadingProgress: loadingProgress,
          ),
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
            (navbarItems.entries.toList()[index].value["callback"] as Function)(
                context, photo);
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
}

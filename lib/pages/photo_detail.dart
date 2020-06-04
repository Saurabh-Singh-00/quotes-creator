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
      "icon": (BuildContext context) => Icon(Icons.info_outline),
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
      "icon": (BuildContext context) => Icon(Icons.favorite_border),
      "callback": (BuildContext context, Photo p) {
        BlocProvider.of<PhotoBloc>(context).add(LikePhoto(p));
      },
    },
    "Edit": {
      "icon": (BuildContext context) => Icon(Icons.mode_edit),
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
    "Save": {
      "icon": (BuildContext context) {
        return StreamBuilder(
          stream: BlocProvider.of<PhotoBloc>(context).downloadPhoto$.stream,
          initialData: false,
          builder: (_, snap) {
            return snap.data
                ? CircularProgressIndicator()
                : Icon(
                    Icons.save_alt,
                    color: snap.data ? Colors.red : Colors.white,
                  );
          },
        );
      },
      "callback": (BuildContext context, Photo p) {
        BlocProvider.of<PhotoBloc>(context).add(
            DownloadPhoto(p.src != null ? p.src.large2x : p.srcFromDbMedium));
      }
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
          photo.src != null ? photo.src.large : photo.srcFromDbOriginal,
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
                  : element.value["icon"](context),
              title: Text(element.key),
            );
          }).toList(),
        ),
      ),
    );
  }
}

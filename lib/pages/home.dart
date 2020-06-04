import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_creator/blocs/photo/search_bloc.dart';
import 'package:insta_creator/blocs/photo/search_event.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/pages/photo_edit.dart';
import 'package:insta_creator/pages/tabs/discover.dart';
import 'package:insta_creator/pages/tabs/favourites.dart';
import 'package:insta_creator/pages/tabs/profile.dart';
import 'package:insta_creator/pages/tabs/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int tabIndex = 0;
  bool isFABVisible = true;
  final ImagePicker picker = ImagePicker();
  final List<String> tabTitle = [
    "Discover",
    "Search",
    "Edit",
    "Favourites",
    "Profile"
  ];
  final List<IconData> tabIcons = [
    Icons.explore,
    Icons.search,
    Icons.add_circle_outline,
    Icons.favorite,
    Icons.account_circle
  ];

  final List<Widget> tabs = [
    DiscoverTab(),
    SearchTab(),
    Container(),
    FavouritesTab(),
    ProfileTab(),
  ];

  Future<Photo> pickedImagePath() async {
    PickedFile imagePath = await picker.getImage(source: ImageSource.gallery);
    if (imagePath != null) {
      var decoded = await decodeImageFromList(
        await imagePath.readAsBytes(),
      );
      return Photo(
          srcFromDbOriginal: imagePath.path,
          width: decoded.width,
          height: decoded.height,
          photographer: BlocProvider.of<UserBloc>(context).repository.username);
    }
    return null;
  }

  @override
  void initState() {
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: tabController.index == 1
            ? isFABVisible
                ? Text(
                    tabTitle[tabController.index],
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                : SearchBar(
                    onCancel: () {
                      setState(() {
                        isFABVisible = !isFABVisible;
                      });
                    },
                    onChanged: (String q) {
                      if (q == "") {
                        BlocProvider.of<SearchBloc>(context).add(ClearSearch());
                      } else {
                        BlocProvider.of<SearchBloc>(context).add(
                          SearchPhoto(
                            query: "$q",
                            continuePrevious: false,
                          ),
                        );
                      }
                    },
                  )
            : Text(
                tabTitle[tabController.index],
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
        // elevation: .0,
        leading: Icon(
          Icons.hdr_strong,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: TabBarView(
        children: tabs,
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: tabController.index == 1
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFABVisible = !isFABVisible;
                });
              },
              backgroundColor: Colors.black,
              child: Icon(isFABVisible ? Icons.search : Icons.clear),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(
                28.0,
              )),
            )
          : null,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          if (index == 2) {
            Photo photo = await pickedImagePath();
            if (photo != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PhotoEditPage(
                    photo: photo,
                    isLocal: true,
                  ),
                ),
              );
            }
            return;
          }
          if (index != tabController.index) {
            tabController.animateTo(index, curve: Curves.fastOutSlowIn);
            setState(() {
              tabController.index = index;
            });
          }
        },
        currentIndex: tabController.index,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        items: tabIcons
            .map(
              (i) => BottomNavigationBarItem(
                icon: Icon(i),
                title: Text(tabTitle[tabController.index]),
              ),
            )
            .toList(),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function onCancel;
  final Function(String) onChanged;

  const SearchBar({Key key, this.onCancel, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      autofocus: true,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: InputBorder.none,
        counterText: "",
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: onCancel,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

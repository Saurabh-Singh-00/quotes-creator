import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';
import 'package:insta_creator/pages/photo_view.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final ScrollController scrollController = ScrollController();

  Widget loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent progress) {
    if (progress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      bloc: BlocProvider.of<PhotoBloc>(context),
      builder: (context, state) {
        return SingleChildScrollView(
          key: PageStorageKey('__user_photo_page_key__'),
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage(
                    BlocProvider.of<UserBloc>(context).repository.avatar,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "@${BlocProvider.of<UserBloc>(context).repository.username}",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pacifico',
                    fontSize: 24.0,
                  ),
                ),
              ),
              FutureBuilder(
                future: BlocProvider.of<PhotoBloc>(context)
                    .repository
                    .fetchUserPhotos(),
                builder: (context, AsyncSnapshot<List<String>> snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    if (snap.hasError) {
                      return Center(
                        child: Text("Oops! Some Error occured."),
                      );
                    }
                    if (snap.data.length == 0) {
                      return Center(
                        child: Text("No photos to display"),
                      );
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PhotoView(
                                  path: snap.data[index],
                                ),
                              ),
                            );
                          },
                          child: Image(
                            image: FileImage(File(snap.data[index])),
                            fit: BoxFit.cover,
                            loadingBuilder: loadingBuilder,
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.black,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

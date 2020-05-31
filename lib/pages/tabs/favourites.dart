import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/widgets/photo_grid.dart';

class FavouritesTab extends StatefulWidget {
  @override
  _FavouritesTabState createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, state) {
        return PhotoGrid(
          scrollController: scrollController,
          photos:
              BlocProvider.of<PhotoBloc>(context).repository.likedPhotosList,
          hasReachedMax: true,
          storageKey: '__favourites_page_key__',
        );
      },
    );
  }
}

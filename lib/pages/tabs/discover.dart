import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_event.dart';
import 'package:insta_creator/blocs/photo/photo_state.dart';
import 'package:insta_creator/widgets/photo_grid.dart';

class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  ScrollController scrollController = ScrollController();
  PhotoBloc photoBloc;
  final double scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    photoBloc = BlocProvider.of<PhotoBloc>(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    final double maxScroll = scrollController.position.maxScrollExtent;
    final double currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      photoBloc.add(FetchPhotos());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      bloc: photoBloc,
      builder: (context, state) {
        if (state is PhotoLoaded) {
          if (state.photos.isEmpty) {
            return Center(child: Text("No results found!"));
          }
          return PhotoGrid(
            scrollController: scrollController,
            photos: state.photos,
            hasReachedMax: state.hasReachedMax,
            storageKey: '__discover_page_key__',
          );
        }
        if (state is PhotoError) {
          return Center(child: Text("${state.e}"));
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
          ),
        );
      },
    );
  }
}

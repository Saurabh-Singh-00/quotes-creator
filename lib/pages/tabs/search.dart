import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/search_bloc.dart';
import 'package:insta_creator/blocs/photo/search_event.dart';
import 'package:insta_creator/blocs/photo/search_state.dart';
import 'package:insta_creator/widgets/photo_grid.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  ScrollController scrollController = ScrollController();
  SearchBloc searchBloc;
  final double scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    searchBloc = BlocProvider.of<SearchBloc>(context);
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
      searchBloc.add(SearchPhoto(
        continuePrevious: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchUninitialized) {
          return Center(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Click on ", style: TextStyle(color: Colors.black)),
                WidgetSpan(
                    child: Icon(
                  Icons.search,
                  size: 16.0,
                )),
                TextSpan(
                    text: " to search a photo",
                    style: TextStyle(color: Colors.black)),
              ]),
            ),
          );
        }
        if (state is SearchResult) {
          if (state.photos.isEmpty) {
            return Center(child: Text("No results found!"));
          }
          return PhotoGrid(
            scrollController: scrollController,
            photos: state.photos,
            hasReachedMax: state.hasReachedMax,
            storageKey: '__search_page_key__',
          );
        }
        if (state is SearchError) {
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

import 'package:insta_creator/models/photo.dart';

abstract class SearchState {}

class SearchUninitialized extends SearchState {}

class Searching extends SearchState {}

class SearchResult extends SearchState {
  final List<Photo> photos;
  final bool hasReachedMax;
  final String nextPage;
  final int totalResults;

  SearchResult({
    this.photos,
    this.hasReachedMax,
    this.nextPage,
    this.totalResults,
  });

  SearchResult copyWith(
      {List<Photo> photos,
      bool hasReachedMax,
      String nextPage,
      int totalResults}) {
    return SearchResult(
        photos: photos ?? this.photos,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        nextPage: nextPage,
        totalResults: totalResults);
  }
}

class SearchError extends SearchState {
  final String e;

  SearchError(this.e);
}

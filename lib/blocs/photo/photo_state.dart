import 'package:insta_creator/models/photo.dart';

abstract class PhotoState {}

class PhotoUninitialized extends PhotoState {
  bool previouslyLoaded = false;
  PhotoUninitialized([this.previouslyLoaded]);
}

class PhotoError extends PhotoState {
  final String e;

  PhotoError(this.e);
}

class PhotoLoaded extends PhotoState {
  final List<Photo> photos;
  final bool hasReachedMax;
  final String nextPage;

  PhotoLoaded({
    this.photos,
    this.hasReachedMax,
    this.nextPage,
  });

  PhotoLoaded copyWith({
    List<Photo> photos,
    bool hasReachedMax,
    String nextPage,
  }) {
    return PhotoLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      nextPage: nextPage,
    );
  }
}

class PhotoSearched extends PhotoState {}

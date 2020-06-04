import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_event.dart';
import 'package:insta_creator/blocs/photo/photo_state.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:insta_creator/repository/photo_repository.dart';

export './photo_state.dart';
export './photo_event.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository repository;
  final StreamController<Photo> likedPhotos$ =
      StreamController<Photo>.broadcast();
  final StreamController<bool> downloadPhoto$ =
      StreamController<bool>.broadcast();

  PhotoBloc({PhotoRepository repository})
      : this.repository = repository ?? PhotoRepository();

  @override
  PhotoState get initialState => PhotoUninitialized();

  @override
  Future<void> close() {
    likedPhotos$.close();
    downloadPhoto$.close();
    return super.close();
  }

  @override
  Stream<Transition<PhotoEvent, PhotoState>> transformEvents(
    Stream<PhotoEvent> events,
    TransitionFunction<PhotoEvent, PhotoState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 150)),
      transitionFn,
    );
  }

  Stream<PhotoState> _mapFetchPhotosToPhotoUninitialized() async* {
    try {
      Map res = await repository.fetchPhotos();
      yield PhotoLoaded(
        photos: res['photos'],
        hasReachedMax: res['hasReachedMax'],
        nextPage: res['nextPage'],
      );
    } catch (e) {
      yield PhotoError(e.toString());
    }
  }

  Stream<PhotoState> _mapFetchPhotosToPhotoLoaded() async* {
    dynamic currentState = state;
    if (currentState is PhotoError) {
      yield* _mapFetchPhotosToPhotoUninitialized();
      return;
    }
    if (!currentState.hasReachedMax) {
      Map res = await repository.fetchPhotos(url: currentState.nextPage);
      if ((res['photos'] as List).isEmpty) {
        yield currentState.copyWith(
            hasReachedMax: true, photos: currentState.photos, nextPage: null);
      } else {
        yield PhotoLoaded(
          photos: currentState.photos + res['photos'],
          hasReachedMax: res['hasReachedMax'],
          nextPage: res['nextPage'],
        );
      }
    }
  }

  void _mapLikePhotoToState(LikePhoto event) async {
    await repository.likePhoto(event.photo);
    likedPhotos$.add(event.photo);
  }

  void _mapDownloadPhotoToState(String url) async {
    downloadPhoto$.sink.add(true);
    await repository.downloadPhoto(url);
    downloadPhoto$.sink.add(false);
  }

  @override
  Stream<PhotoState> mapEventToState(PhotoEvent event) async* {
    PhotoState currentState = state;
    if (event is FetchPhotos) {
      try {
        if (currentState is PhotoUninitialized) {
          yield* _mapFetchPhotosToPhotoUninitialized();
          return;
        }
        if (currentState is PhotoLoaded) {
          yield* _mapFetchPhotosToPhotoLoaded();
        }
        if (currentState is PhotoError) {
          yield* _mapFetchPhotosToPhotoLoaded();
        }
      } catch (e) {
        yield PhotoError(e.toString());
      }
    }
    if (event is LikePhoto) {
      _mapLikePhotoToState(event);
    }
    if (event is DownloadPhoto) {
      _mapDownloadPhotoToState(event.url);
    }
  }
}

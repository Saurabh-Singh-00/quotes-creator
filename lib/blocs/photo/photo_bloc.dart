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
  final PhotoRepository repository = PhotoRepository();
  final StreamController<Photo> likedPhotos$ =
      StreamController<Photo>.broadcast();

  @override
  PhotoState get initialState => PhotoUninitialized();

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

  @override
  Stream<PhotoState> mapEventToState(PhotoEvent event) async* {
    PhotoState currentState = state;
    if (event is FetchPhotos) {
      try {
        if (currentState is PhotoUninitialized) {
          Map res = await repository.fetchPhotos();
          yield PhotoLoaded(
              photos: res['photos'],
              hasReachedMax: res['hasReachedMax'],
              nextPage: res['nextPage']);
          return;
        }
        if (currentState is PhotoLoaded) {
          if (!currentState.hasReachedMax) {
            Map res = await repository.fetchPhotos(url: currentState.nextPage);
            yield (res['photos'] as List).isEmpty
                ? currentState.copyWith(
                    hasReachedMax: true,
                    photos: currentState.photos,
                    nextPage: null)
                : PhotoLoaded(
                    photos: currentState.photos + res['photos'],
                    hasReachedMax: res['hasReachedMax'],
                    nextPage: res['nextPage'],
                  );
          }
        }
      } catch (e) {
        yield PhotoError(e.toString());
      }
    }
    if (event is LikePhoto) {
      if (repository.likedPhotos.contains(event.photo.id)) {
        repository.likedPhotos.remove(event.photo.id);
      } else {
        repository.likedPhotos.add(event.photo.id);
      }
      event.photo.isLiked = !event.photo.isLiked;
      likedPhotos$.add(event.photo);
    }
  }
}

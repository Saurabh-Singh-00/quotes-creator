import 'package:insta_creator/models/photo.dart';

abstract class PhotoEvent {}

class FetchPhotos extends PhotoEvent {}

class LikePhoto extends PhotoEvent {
  final Photo photo;

  LikePhoto(this.photo);
}

class SavePhoto extends PhotoEvent {
  final Photo photo;

  SavePhoto(this.photo);
}

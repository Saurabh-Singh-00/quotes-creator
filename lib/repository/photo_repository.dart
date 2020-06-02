import 'dart:io';

import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/services/api.dart';
import 'package:insta_creator/secrets/keys.dart';
import 'package:insta_creator/services/db.dart';
import 'package:insta_creator/services/storage.dart';
import 'package:sqflite/sqflite.dart';

class PhotoRepository {
  /// Using [API] class as Data Provider with CRUD methods
  final API api = API();
  final DBClient dbClient = DBClient();

  final String photoUrl = "https://api.pexels.com/v1/curated/";
  final String searchUrl = "https://api.pexels.com/v1/search?page=1&query=";
  final Set likedPhotos = Set();
  final List<Photo> likedPhotosList = [];
  List<String> userPhotosList;

  Future likePhoto(Photo photo) async {
    Database db = await dbClient.db;
    try {
      if (photo.isLiked) {
        likedPhotos.remove(photo.id);
        photo.isLiked = false;
        await db.delete(dbClient.favouritesTableName,
            where: "id = ?", whereArgs: [photo.id]);
        likedPhotosList.remove(photo);
      } else {
        likedPhotos.add(photo.id);
        photo.isLiked = true;
        await db.insert(dbClient.favouritesTableName, photo.toDbJson());
        likedPhotosList.add(photo);
      }
    } catch (e) {
      print(e);
    }
  }

  get pexelKey => Keys.pexelKey;

  Future<Map> fetchPhotos({String url}) async {
    List<Photo> photos = [];
    Map result = Map();
    dynamic res = await api.get(url: url ?? photoUrl, authKey: pexelKey);
    for (Map json in res['photos']) {
      Photo p = Photo.fromJson(json);
      if (likedPhotos.contains(p.id)) {
        p.isLiked = true;
      }
      photos.add(p);
    }
    result['photos'] = photos;
    result['nextPage'] = res['next_page'] ?? null;
    result['hasReachedMax'] = res['next_page'] == null;
    return result;
  }

  Future<List<String>> getRecentSearches() async {
    await Future.delayed(Duration(milliseconds: 300));
    return ["Nature", "Birds", "Pillows"];
  }

  Future<Map> fetchSearchReasults({String query, String url}) async {
    List<Photo> photos = [];
    Map result = Map();
    dynamic res =
        await api.get(url: url ?? (searchUrl + query), authKey: pexelKey);
    for (Map json in res['photos']) {
      Photo p = Photo.fromJson(json);
      if (likedPhotos.contains(p.id)) {
        p.isLiked = true;
      }
      photos.add(p);
    }
    result['photos'] = photos;
    result['totalResults'] = res['total_results'];
    result['nextPage'] = res['next_page'] ?? null;
    result['hasReachedMax'] = res['next_page'] == null;
    return result;
  }

  Future<List<Photo>> fetchFavouritePhotos() async {
    Database db = await dbClient.db;
    List<Map<String, dynamic>> res =
        await db.query(dbClient.favouritesTableName);
    for (Map<String, dynamic> json in res) {
      likedPhotosList.add(Photo.fromDbJson(json)..isLiked = true);
      likedPhotos.add(json['id']);
    }
    return likedPhotosList;
  }

  Future<List<String>> fetchUserPhotos() async {
    if (userPhotosList == null) {
      userPhotosList = [];
      List<FileSystemEntity> imageFiles = await Storage.getExternalPhotosPath();
      for (FileSystemEntity file in imageFiles) {
        userPhotosList.add(file.path);
      }
    }
    return userPhotosList;
  }

  void addPhotoToSavedList(String path) async {
    if (userPhotosList == null) {
      await fetchUserPhotos();
    } else {
      userPhotosList.add(path);
    }
  }
}

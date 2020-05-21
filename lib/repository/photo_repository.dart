import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/services/api.dart';
import 'package:insta_creator/secrets/keys.dart';

class PhotoRepository {
  /// Using [API] class as Data Provider with CRUD methods
  final API api = API();

  final String photoUrl = "https://api.pexels.com/v1/curated/";
  final String searchUrl = "https://api.pexels.com/v1/search?page=1&query=";
  final Set likedPhotos = Set();

  void likePhoto(int photoId) {
    likedPhotos.add(photoId);
  }

  get pexelKey => Keys.pexelKey;

  Future<Map> fetchPhotos({String url}) async {
    List<Photo> photos = [];
    Map result = Map();
    dynamic res = await api.get(url: url ?? photoUrl, authKey: pexelKey);
    for (Map json in res['photos']) {
      photos.add(Photo.fromJson(json));
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
      photos.add(Photo.fromJson(json));
    }
    result['photos'] = photos;
    result['totalResults'] = res['total_results'];
    result['nextPage'] = res['next_page'] ?? null;
    result['hasReachedMax'] = res['next_page'] == null;
    return result;
  }
}

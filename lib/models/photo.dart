import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Photo {
  int id;
  int width;
  int height;
  String url;
  String photographer;
  String photographerUrl;
  int photographerId;
  Src src;
  @JsonKey(defaultValue: false)
  bool isLiked;
  String srcFromDbMedium;
  String srcFromDbOriginal;

  Photo(
      {this.id,
      this.width,
      this.height,
      this.url,
      this.photographer,
      this.photographerUrl,
      this.photographerId,
      this.src,
      this.srcFromDbMedium,
      this.srcFromDbOriginal});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  factory Photo.fromDbJson(Map<String, dynamic> json) =>
      _$PhotoFromDbJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  Map<String, dynamic> toDbJson() => _$PhotoToDbJson(this);

  @override
  bool operator ==(covariant Photo other) {
    return this.id == other.id;
  }

  @override
  int get hashCode => super.hashCode;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Src {
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  Src(
      {this.original,
      this.large2x,
      this.large,
      this.medium,
      this.small,
      this.portrait,
      this.landscape,
      this.tiny});

  factory Src.fromJson(Map<String, dynamic> json) => _$SrcFromJson(json);

  Map<String, dynamic> toJson() => _$SrcToJson(this);
}

Photo _$PhotoFromDbJson(Map<String, dynamic> json) {
  return Photo(
    id: json['id'] as int,
    width: json['width'] as int,
    height: json['height'] as int,
    url: json['url'] as String,
    photographer: json['photographer'] as String,
    photographerUrl: json['photographer_url'] as String,
    photographerId: json['photographer_id'] as int,
    srcFromDbMedium: json['src_from_db_medium'] as String,
    srcFromDbOriginal: json['src_from_db_original'] as String,
  );
}

Map<String, dynamic> _$PhotoToDbJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'photographer': instance.photographer,
      'photographer_url': instance.photographerUrl,
      'photographer_id': instance.photographerId,
      'src_from_db_medium':
          instance.src != null ? instance.src.medium : instance.srcFromDbMedium,
      'src_from_db_original': instance.src != null
          ? instance.src.original
          : instance.srcFromDbOriginal,
    };

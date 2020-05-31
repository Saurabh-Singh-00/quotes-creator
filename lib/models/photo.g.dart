// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    id: json['id'] as int,
    width: json['width'] as int,
    height: json['height'] as int,
    url: json['url'] as String,
    photographer: json['photographer'] as String,
    photographerUrl: json['photographer_url'] as String,
    photographerId: json['photographer_id'] as int,
    src: json['src'] == null
        ? null
        : Src.fromJson(json['src'] as Map<String, dynamic>),
    srcFromDbMedium: json['src_from_db_medium'] as String,
    srcFromDbOriginal: json['src_from_db_original'] as String,
  )..isLiked = json['is_liked'] as bool ?? false;
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'photographer': instance.photographer,
      'photographer_url': instance.photographerUrl,
      'photographer_id': instance.photographerId,
      'src': instance.src,
      'is_liked': instance.isLiked,
      'src_from_db_medium': instance.src.medium,
      'src_from_db_original': instance.src.original,
    };

Src _$SrcFromJson(Map<String, dynamic> json) {
  return Src(
    original: json['original'] as String,
    large2x: json['large2x'] as String,
    large: json['large'] as String,
    medium: json['medium'] as String,
    small: json['small'] as String,
    portrait: json['portrait'] as String,
    landscape: json['landscape'] as String,
    tiny: json['tiny'] as String,
  );
}

Map<String, dynamic> _$SrcToJson(Src instance) => <String, dynamic>{
      'original': instance.original,
      'large2x': instance.large2x,
      'large': instance.large,
      'medium': instance.medium,
      'small': instance.small,
      'portrait': instance.portrait,
      'landscape': instance.landscape,
      'tiny': instance.tiny,
    };

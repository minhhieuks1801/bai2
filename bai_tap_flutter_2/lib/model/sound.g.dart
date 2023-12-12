// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sound _$SoundFromJson(Map<String, dynamic> json) => Sound(
      key: json['key'] as String?,
      name: json['name'] as String?,
      link: json['link'] as String?,
      linkAnh: json['linkAnh'] as String?,
      tacGia: json['tacGia'] as String?,
      image: json['image'] as String?,
      thoiGian: json['thoiGian'] as String?,
    );

Map<String, dynamic> _$SoundToJson(Sound instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'link': instance.link,
      'linkAnh': instance.linkAnh,
      'tacGia': instance.tacGia,
      'image': instance.image,
      'thoiGian': instance.thoiGian,
    };

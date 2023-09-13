// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      category: json['category'] as String?,
      heading: json['heading'] as String?,
      description: json['description'] as String?,
      companylink: json['companylink'] as String,
      file: json['file'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'category': instance.category,
      'heading': instance.heading,
      'description': instance.description,
      'companylink': instance.companylink,
      'file': instance.file,
      'user': instance.user,
    };

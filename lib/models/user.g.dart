// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      hired: json['hired'] as String,
      availability: json['availability'] as String,
      category: json['category'] as String,
      payment: json['payment'] as String,
      rating: json['rating'] as String,
      online: json['online'] as String,
      enabled: json['enabled'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'bio': instance.bio,
      'hired': instance.hired,
      'availability': instance.availability,
      'category': instance.category,
      'payment': instance.payment,
      'rating': instance.rating,
      'online': instance.online,
      'enabled': instance.enabled,
    };

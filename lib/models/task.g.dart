// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      category: json['category'] as String?,
      description: json['description'] as String?,
      payment: json['payment'] as String?,
      startdate: json['startdate'] as String?,
      enddate: json['enddate'] as String?,
      status: json['status'] as String?,
      paid: json['paid'] as String?,
      userId: json['userId'] as int?,
      recipientId: json['recipientId'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      recipient: json['recipient'] == null
          ? null
          : Recipient.fromJson(json['recipient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'category': instance.category,
      'description': instance.description,
      'payment': instance.payment,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'status': instance.status,
      'paid': instance.paid,
      'userId': instance.userId,
      'recipientId': instance.recipientId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'recipient': instance.recipient?.toJson(),
    };

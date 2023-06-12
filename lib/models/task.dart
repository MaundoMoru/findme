import 'package:findme/models/recipient.dart';
import 'package:findme/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  final String? category;
  final String? description;
  final String? payment;
  final String? startdate;
  final String? enddate;
  final String? status;
  final String? paid;
  final int? userId;
  final int? recipientId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final Recipient? recipient;

  const Task({
    required this.category,
    required this.description,
    required this.payment,
    required this.startdate,
    required this.enddate,
    required this.status,
    required this.paid,
    required this.userId,
    required this.recipientId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.recipient,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

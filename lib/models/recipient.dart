import 'package:findme/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipient.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipient {
  final int id;
  final int taskId;
  final int userId;
  final User user;

  const Recipient({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.user,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);
  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

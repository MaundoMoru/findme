import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String image;
  final String name;
  final String bio;
  final String hired;
  final String availability;
  final String category;
  final String payment;
  final String rating;
  final String online;

  const User({
    required this.id,
    required this.image,
    required this.name,
    required this.bio,
    required this.hired,
    required this.availability,
    required this.category,
    required this.payment,
    required this.rating,
    required this.online,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

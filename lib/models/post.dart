import 'package:findme/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int? id;
  final int? userId;
  final String? category;
  final String? heading;
  final String? description;
  final String companylink;
  final String? file;
  final User? user;

  const Post({
    required this.id,
    required this.userId,
    required this.category,
    required this.heading,
    required this.description,
    required this.companylink,
    required this.file,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

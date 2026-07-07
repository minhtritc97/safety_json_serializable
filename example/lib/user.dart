import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Demo model covering every type category that differs between
/// `json_serializable` and `safety_json_serializable` when the generator
/// runs:
///
/// - primitive scalar (`int`, `double`, `bool`, `String`)
/// - `BigInt` / `DateTime` / `Uri` (types with custom parsing)
/// - `List<primitive>`
/// - nested custom class (`User? manager`)
/// - `List<CustomClass>` (`List<User>? friends`)
/// - `Map<String, dynamic>` (loose/dynamic payload)
@JsonSerializable()
class User {
  final int? id;
  final String? name;
  final bool? isActive;
  final double? balance;
  final BigInt? externalId;
  final DateTime? createdAt;
  final Uri? avatarUrl;

  /// List of primitives — highlights the `is List` check fix.
  final List<int>? scoreHistory;

  /// Nested custom model — highlights the `is! Map` check fix.
  final User? manager;

  /// List of custom models — highlights both fixes combined.
  final List<User>? friends;

  /// Loose/dynamic payload straight from the backend.
  final Map<String, dynamic>? metadata;

  const User({
    this.id,
    this.name,
    this.isActive,
    this.balance,
    this.externalId,
    this.createdAt,
    this.avatarUrl,
    this.scoreHistory,
    this.manager,
    this.friends,
    this.metadata,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
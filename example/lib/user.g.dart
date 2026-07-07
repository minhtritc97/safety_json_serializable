// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: double.tryParse(json['id'].toString())?.toInt(),
  name: json['name']?.toString(),
  isActive: bool.tryParse(json['isActive'].toString()),
  balance: double.tryParse(json['balance'].toString()),
  externalId: json['externalId'] == null
      ? null
      : BigInt.tryParse(json['externalId'].toString()),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.tryParse(json['createdAt'].toString()),
  avatarUrl: json['avatarUrl'] == null
      ? null
      : Uri.tryParse(json['avatarUrl'].toString()),
  scoreHistory: (json['scoreHistory'] is List)
      ? (json['scoreHistory'] as List<dynamic>?)?.map((e) => e as int).toList()
      : [],
  manager: json['manager'] == null || json['manager'] is! Map
      ? null
      : User.fromJson(json['manager'] as Map<String, dynamic>),
  friends: (json['friends'] is List)
      ? (json['friends'] as List<dynamic>?)
            ?.map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList()
      : [],
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isActive': instance.isActive,
  'balance': instance.balance,
  'externalId': instance.externalId?.toString(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'avatarUrl': instance.avatarUrl?.toString(),
  'scoreHistory': instance.scoreHistory,
  'manager': instance.manager,
  'friends': instance.friends,
  'metadata': instance.metadata,
};

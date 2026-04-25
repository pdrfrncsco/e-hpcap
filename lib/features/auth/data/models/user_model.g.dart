// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      telefone: json['telefone'] as String?,
      biografia: json['biografia'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'telefone': instance.telefone,
      'biografia': instance.biografia,
    };

const _$UserRoleEnumMap = {
  UserRole.membro: 'membro',
  UserRole.igreja: 'igreja',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distrito.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DistritoImpl _$$DistritoImplFromJson(Map<String, dynamic> json) =>
    _$DistritoImpl(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      conferencia: json['conferencia'] == null
          ? null
          : Conferencia.fromJson(json['conferencia'] as Map<String, dynamic>),
      superintendente: json['superintendente'] as String?,
      totalIgrejas: (json['total_igrejas'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DistritoImplToJson(_$DistritoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'conferencia': instance.conferencia,
      'superintendente': instance.superintendente,
      'total_igrejas': instance.totalIgrejas,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conferencia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConferenciaImpl _$$ConferenciaImplFromJson(Map<String, dynamic> json) =>
    _$ConferenciaImpl(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      codigo: json['codigo'] as String,
      bispo: json['bispo'] as String?,
      sede: json['sede'] as String?,
    );

Map<String, dynamic> _$$ConferenciaImplToJson(_$ConferenciaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'codigo': instance.codigo,
      'bispo': instance.bispo,
      'sede': instance.sede,
    };

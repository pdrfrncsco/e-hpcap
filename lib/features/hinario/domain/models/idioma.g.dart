// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idioma.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IdiomaImpl _$$IdiomaImplFromJson(Map<String, dynamic> json) => _$IdiomaImpl(
      codigo: json['codigo'] as String,
      nome: json['nome'] as String,
      totalHinos: (json['total_hinos'] as num).toInt(),
    );

Map<String, dynamic> _$$IdiomaImplToJson(_$IdiomaImpl instance) =>
    <String, dynamic>{
      'codigo': instance.codigo,
      'nome': instance.nome,
      'total_hinos': instance.totalHinos,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estrofe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EstrofeImpl _$$EstrofeImplFromJson(Map<String, dynamic> json) =>
    _$EstrofeImpl(
      ordem: (json['ordem'] as num).toInt(),
      numeroNoTipo: (json['numero_no_tipo'] as num?)?.toInt(),
      label: json['label'] as String?,
      tipo: json['tipo'] as String,
      texto: json['texto'] as String,
      versos:
          (json['versos'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$EstrofeImplToJson(_$EstrofeImpl instance) =>
    <String, dynamic>{
      'ordem': instance.ordem,
      'numero_no_tipo': instance.numeroNoTipo,
      'label': instance.label,
      'tipo': instance.tipo,
      'texto': instance.texto,
      'versos': instance.versos,
    };

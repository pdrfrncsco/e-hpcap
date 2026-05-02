// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'texto_liturgico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TextoLiturgicoImpl _$$TextoLiturgicoImplFromJson(Map<String, dynamic> json) =>
    _$TextoLiturgicoImpl(
      id: (json['id'] as num).toInt(),
      tipo: json['tipo'] as String,
      tipoDisplay: json['tipo_display'] as String,
      idioma: json['idioma'] as String?,
      titulo: json['titulo'] as String,
      conteudo: json['conteudo'] as String,
      ordem: (json['ordem'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$TextoLiturgicoImplToJson(
        _$TextoLiturgicoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': instance.tipo,
      'tipo_display': instance.tipoDisplay,
      'idioma': instance.idioma,
      'titulo': instance.titulo,
      'conteudo': instance.conteudo,
      'ordem': instance.ordem,
    };

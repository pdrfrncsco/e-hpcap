// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hino.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HinoImpl _$$HinoImplFromJson(Map<String, dynamic> json) => _$HinoImpl(
      id: (json['id'] as num).toInt(),
      secao: json['secao'] as String,
      numero: (json['numero'] as num).toInt(),
      titulo: json['titulo'] as String,
      temas: (json['temas'] as List<dynamic>?)
              ?.map((e) => Tema.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      idioma: json['idioma'] == null
          ? null
          : Idioma.fromJson(json['idioma'] as Map<String, dynamic>),
      referencia: json['referencia'] as String?,
      estrofes: (json['estrofes'] as List<dynamic>?)
          ?.map((e) => Estrofe.fromJson(e as Map<String, dynamic>))
          .toList(),
      letraDe: json['letra_de'] as String?,
      musicaDe: json['musica_de'] as String?,
    );

Map<String, dynamic> _$$HinoImplToJson(_$HinoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'secao': instance.secao,
      'numero': instance.numero,
      'titulo': instance.titulo,
      'temas': instance.temas,
      'idioma': instance.idioma,
      'referencia': instance.referencia,
      'estrofes': instance.estrofes,
      'letra_de': instance.letraDe,
      'musica_de': instance.musicaDe,
    };

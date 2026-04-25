// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'igreja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IgrejaImpl _$$IgrejaImplFromJson(Map<String, dynamic> json) => _$IgrejaImpl(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      pastor: json['pastor'] as String,
      cidade: json['cidade'] as String,
      distritoNome: json['distrito_nome'] as String?,
      conferenciaCodigo: json['conferencia_codigo'] as String?,
      distrito: json['distrito'] == null
          ? null
          : Distrito.fromJson(json['distrito'] as Map<String, dynamic>),
      kuid: json['kuid'] as String?,
      provincia: json['provincia'] as String?,
      morada: json['morada'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      telefone: json['telefone'] as String?,
      email: json['email'] as String?,
      horarioCulto: json['horario_culto'] as String?,
      foto: json['foto'] as String?,
      site: json['site'] as String?,
      dataFundacao: json['data_fundacao'] as String?,
      distanciaKm: (json['distancia_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$IgrejaImplToJson(_$IgrejaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'pastor': instance.pastor,
      'cidade': instance.cidade,
      'distrito_nome': instance.distritoNome,
      'conferencia_codigo': instance.conferenciaCodigo,
      'distrito': instance.distrito,
      'kuid': instance.kuid,
      'provincia': instance.provincia,
      'morada': instance.morada,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'telefone': instance.telefone,
      'email': instance.email,
      'horario_culto': instance.horarioCulto,
      'foto': instance.foto,
      'site': instance.site,
      'data_fundacao': instance.dataFundacao,
      'distancia_km': instance.distanciaKm,
    };

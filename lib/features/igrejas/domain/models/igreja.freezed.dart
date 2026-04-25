// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'igreja.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Igreja _$IgrejaFromJson(Map<String, dynamic> json) {
  return _Igreja.fromJson(json);
}

/// @nodoc
mixin _$Igreja {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get pastor => throw _privateConstructorUsedError;
  String get cidade =>
      throw _privateConstructorUsedError; // Na listagem podemos receber apenas o nome do distrito e codigo da conf
  @JsonKey(name: 'distrito_nome')
  String? get distritoNome => throw _privateConstructorUsedError;
  @JsonKey(name: 'conferencia_codigo')
  String? get conferenciaCodigo =>
      throw _privateConstructorUsedError; // No detalhe recebemos o objeto completo do distrito
  Distrito? get distrito => throw _privateConstructorUsedError;
  String? get kuid => throw _privateConstructorUsedError;
  String? get provincia => throw _privateConstructorUsedError;
  String? get morada => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get longitude => throw _privateConstructorUsedError;
  String? get telefone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'horario_culto')
  String? get horarioCulto => throw _privateConstructorUsedError;
  String? get foto => throw _privateConstructorUsedError;
  String? get site => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_fundacao')
  String? get dataFundacao =>
      throw _privateConstructorUsedError; // Para as igrejas próximas
  @JsonKey(name: 'distancia_km')
  double? get distanciaKm => throw _privateConstructorUsedError;

  /// Serializes this Igreja to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IgrejaCopyWith<Igreja> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IgrejaCopyWith<$Res> {
  factory $IgrejaCopyWith(Igreja value, $Res Function(Igreja) then) =
      _$IgrejaCopyWithImpl<$Res, Igreja>;
  @useResult
  $Res call(
      {int id,
      String nome,
      String pastor,
      String cidade,
      @JsonKey(name: 'distrito_nome') String? distritoNome,
      @JsonKey(name: 'conferencia_codigo') String? conferenciaCodigo,
      Distrito? distrito,
      String? kuid,
      String? provincia,
      String? morada,
      @JsonKey(fromJson: _parseDouble) double? latitude,
      @JsonKey(fromJson: _parseDouble) double? longitude,
      String? telefone,
      String? email,
      @JsonKey(name: 'horario_culto') String? horarioCulto,
      String? foto,
      String? site,
      @JsonKey(name: 'data_fundacao') String? dataFundacao,
      @JsonKey(name: 'distancia_km') double? distanciaKm});

  $DistritoCopyWith<$Res>? get distrito;
}

/// @nodoc
class _$IgrejaCopyWithImpl<$Res, $Val extends Igreja>
    implements $IgrejaCopyWith<$Res> {
  _$IgrejaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? pastor = null,
    Object? cidade = null,
    Object? distritoNome = freezed,
    Object? conferenciaCodigo = freezed,
    Object? distrito = freezed,
    Object? kuid = freezed,
    Object? provincia = freezed,
    Object? morada = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? telefone = freezed,
    Object? email = freezed,
    Object? horarioCulto = freezed,
    Object? foto = freezed,
    Object? site = freezed,
    Object? dataFundacao = freezed,
    Object? distanciaKm = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      pastor: null == pastor
          ? _value.pastor
          : pastor // ignore: cast_nullable_to_non_nullable
              as String,
      cidade: null == cidade
          ? _value.cidade
          : cidade // ignore: cast_nullable_to_non_nullable
              as String,
      distritoNome: freezed == distritoNome
          ? _value.distritoNome
          : distritoNome // ignore: cast_nullable_to_non_nullable
              as String?,
      conferenciaCodigo: freezed == conferenciaCodigo
          ? _value.conferenciaCodigo
          : conferenciaCodigo // ignore: cast_nullable_to_non_nullable
              as String?,
      distrito: freezed == distrito
          ? _value.distrito
          : distrito // ignore: cast_nullable_to_non_nullable
              as Distrito?,
      kuid: freezed == kuid
          ? _value.kuid
          : kuid // ignore: cast_nullable_to_non_nullable
              as String?,
      provincia: freezed == provincia
          ? _value.provincia
          : provincia // ignore: cast_nullable_to_non_nullable
              as String?,
      morada: freezed == morada
          ? _value.morada
          : morada // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      telefone: freezed == telefone
          ? _value.telefone
          : telefone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      horarioCulto: freezed == horarioCulto
          ? _value.horarioCulto
          : horarioCulto // ignore: cast_nullable_to_non_nullable
              as String?,
      foto: freezed == foto
          ? _value.foto
          : foto // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      dataFundacao: freezed == dataFundacao
          ? _value.dataFundacao
          : dataFundacao // ignore: cast_nullable_to_non_nullable
              as String?,
      distanciaKm: freezed == distanciaKm
          ? _value.distanciaKm
          : distanciaKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DistritoCopyWith<$Res>? get distrito {
    if (_value.distrito == null) {
      return null;
    }

    return $DistritoCopyWith<$Res>(_value.distrito!, (value) {
      return _then(_value.copyWith(distrito: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IgrejaImplCopyWith<$Res> implements $IgrejaCopyWith<$Res> {
  factory _$$IgrejaImplCopyWith(
          _$IgrejaImpl value, $Res Function(_$IgrejaImpl) then) =
      __$$IgrejaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nome,
      String pastor,
      String cidade,
      @JsonKey(name: 'distrito_nome') String? distritoNome,
      @JsonKey(name: 'conferencia_codigo') String? conferenciaCodigo,
      Distrito? distrito,
      String? kuid,
      String? provincia,
      String? morada,
      @JsonKey(fromJson: _parseDouble) double? latitude,
      @JsonKey(fromJson: _parseDouble) double? longitude,
      String? telefone,
      String? email,
      @JsonKey(name: 'horario_culto') String? horarioCulto,
      String? foto,
      String? site,
      @JsonKey(name: 'data_fundacao') String? dataFundacao,
      @JsonKey(name: 'distancia_km') double? distanciaKm});

  @override
  $DistritoCopyWith<$Res>? get distrito;
}

/// @nodoc
class __$$IgrejaImplCopyWithImpl<$Res>
    extends _$IgrejaCopyWithImpl<$Res, _$IgrejaImpl>
    implements _$$IgrejaImplCopyWith<$Res> {
  __$$IgrejaImplCopyWithImpl(
      _$IgrejaImpl _value, $Res Function(_$IgrejaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? pastor = null,
    Object? cidade = null,
    Object? distritoNome = freezed,
    Object? conferenciaCodigo = freezed,
    Object? distrito = freezed,
    Object? kuid = freezed,
    Object? provincia = freezed,
    Object? morada = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? telefone = freezed,
    Object? email = freezed,
    Object? horarioCulto = freezed,
    Object? foto = freezed,
    Object? site = freezed,
    Object? dataFundacao = freezed,
    Object? distanciaKm = freezed,
  }) {
    return _then(_$IgrejaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      pastor: null == pastor
          ? _value.pastor
          : pastor // ignore: cast_nullable_to_non_nullable
              as String,
      cidade: null == cidade
          ? _value.cidade
          : cidade // ignore: cast_nullable_to_non_nullable
              as String,
      distritoNome: freezed == distritoNome
          ? _value.distritoNome
          : distritoNome // ignore: cast_nullable_to_non_nullable
              as String?,
      conferenciaCodigo: freezed == conferenciaCodigo
          ? _value.conferenciaCodigo
          : conferenciaCodigo // ignore: cast_nullable_to_non_nullable
              as String?,
      distrito: freezed == distrito
          ? _value.distrito
          : distrito // ignore: cast_nullable_to_non_nullable
              as Distrito?,
      kuid: freezed == kuid
          ? _value.kuid
          : kuid // ignore: cast_nullable_to_non_nullable
              as String?,
      provincia: freezed == provincia
          ? _value.provincia
          : provincia // ignore: cast_nullable_to_non_nullable
              as String?,
      morada: freezed == morada
          ? _value.morada
          : morada // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      telefone: freezed == telefone
          ? _value.telefone
          : telefone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      horarioCulto: freezed == horarioCulto
          ? _value.horarioCulto
          : horarioCulto // ignore: cast_nullable_to_non_nullable
              as String?,
      foto: freezed == foto
          ? _value.foto
          : foto // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      dataFundacao: freezed == dataFundacao
          ? _value.dataFundacao
          : dataFundacao // ignore: cast_nullable_to_non_nullable
              as String?,
      distanciaKm: freezed == distanciaKm
          ? _value.distanciaKm
          : distanciaKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IgrejaImpl extends _Igreja {
  const _$IgrejaImpl(
      {required this.id,
      required this.nome,
      required this.pastor,
      required this.cidade,
      @JsonKey(name: 'distrito_nome') this.distritoNome,
      @JsonKey(name: 'conferencia_codigo') this.conferenciaCodigo,
      this.distrito,
      this.kuid,
      this.provincia,
      this.morada,
      @JsonKey(fromJson: _parseDouble) this.latitude,
      @JsonKey(fromJson: _parseDouble) this.longitude,
      this.telefone,
      this.email,
      @JsonKey(name: 'horario_culto') this.horarioCulto,
      this.foto,
      this.site,
      @JsonKey(name: 'data_fundacao') this.dataFundacao,
      @JsonKey(name: 'distancia_km') this.distanciaKm})
      : super._();

  factory _$IgrejaImpl.fromJson(Map<String, dynamic> json) =>
      _$$IgrejaImplFromJson(json);

  @override
  final int id;
  @override
  final String nome;
  @override
  final String pastor;
  @override
  final String cidade;
// Na listagem podemos receber apenas o nome do distrito e codigo da conf
  @override
  @JsonKey(name: 'distrito_nome')
  final String? distritoNome;
  @override
  @JsonKey(name: 'conferencia_codigo')
  final String? conferenciaCodigo;
// No detalhe recebemos o objeto completo do distrito
  @override
  final Distrito? distrito;
  @override
  final String? kuid;
  @override
  final String? provincia;
  @override
  final String? morada;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? latitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? longitude;
  @override
  final String? telefone;
  @override
  final String? email;
  @override
  @JsonKey(name: 'horario_culto')
  final String? horarioCulto;
  @override
  final String? foto;
  @override
  final String? site;
  @override
  @JsonKey(name: 'data_fundacao')
  final String? dataFundacao;
// Para as igrejas próximas
  @override
  @JsonKey(name: 'distancia_km')
  final double? distanciaKm;

  @override
  String toString() {
    return 'Igreja(id: $id, nome: $nome, pastor: $pastor, cidade: $cidade, distritoNome: $distritoNome, conferenciaCodigo: $conferenciaCodigo, distrito: $distrito, kuid: $kuid, provincia: $provincia, morada: $morada, latitude: $latitude, longitude: $longitude, telefone: $telefone, email: $email, horarioCulto: $horarioCulto, foto: $foto, site: $site, dataFundacao: $dataFundacao, distanciaKm: $distanciaKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IgrejaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.pastor, pastor) || other.pastor == pastor) &&
            (identical(other.cidade, cidade) || other.cidade == cidade) &&
            (identical(other.distritoNome, distritoNome) ||
                other.distritoNome == distritoNome) &&
            (identical(other.conferenciaCodigo, conferenciaCodigo) ||
                other.conferenciaCodigo == conferenciaCodigo) &&
            (identical(other.distrito, distrito) ||
                other.distrito == distrito) &&
            (identical(other.kuid, kuid) || other.kuid == kuid) &&
            (identical(other.provincia, provincia) ||
                other.provincia == provincia) &&
            (identical(other.morada, morada) || other.morada == morada) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.telefone, telefone) ||
                other.telefone == telefone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.horarioCulto, horarioCulto) ||
                other.horarioCulto == horarioCulto) &&
            (identical(other.foto, foto) || other.foto == foto) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.dataFundacao, dataFundacao) ||
                other.dataFundacao == dataFundacao) &&
            (identical(other.distanciaKm, distanciaKm) ||
                other.distanciaKm == distanciaKm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nome,
        pastor,
        cidade,
        distritoNome,
        conferenciaCodigo,
        distrito,
        kuid,
        provincia,
        morada,
        latitude,
        longitude,
        telefone,
        email,
        horarioCulto,
        foto,
        site,
        dataFundacao,
        distanciaKm
      ]);

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IgrejaImplCopyWith<_$IgrejaImpl> get copyWith =>
      __$$IgrejaImplCopyWithImpl<_$IgrejaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IgrejaImplToJson(
      this,
    );
  }
}

abstract class _Igreja extends Igreja {
  const factory _Igreja(
      {required final int id,
      required final String nome,
      required final String pastor,
      required final String cidade,
      @JsonKey(name: 'distrito_nome') final String? distritoNome,
      @JsonKey(name: 'conferencia_codigo') final String? conferenciaCodigo,
      final Distrito? distrito,
      final String? kuid,
      final String? provincia,
      final String? morada,
      @JsonKey(fromJson: _parseDouble) final double? latitude,
      @JsonKey(fromJson: _parseDouble) final double? longitude,
      final String? telefone,
      final String? email,
      @JsonKey(name: 'horario_culto') final String? horarioCulto,
      final String? foto,
      final String? site,
      @JsonKey(name: 'data_fundacao') final String? dataFundacao,
      @JsonKey(name: 'distancia_km') final double? distanciaKm}) = _$IgrejaImpl;
  const _Igreja._() : super._();

  factory _Igreja.fromJson(Map<String, dynamic> json) = _$IgrejaImpl.fromJson;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get pastor;
  @override
  String
      get cidade; // Na listagem podemos receber apenas o nome do distrito e codigo da conf
  @override
  @JsonKey(name: 'distrito_nome')
  String? get distritoNome;
  @override
  @JsonKey(name: 'conferencia_codigo')
  String?
      get conferenciaCodigo; // No detalhe recebemos o objeto completo do distrito
  @override
  Distrito? get distrito;
  @override
  String? get kuid;
  @override
  String? get provincia;
  @override
  String? get morada;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get latitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get longitude;
  @override
  String? get telefone;
  @override
  String? get email;
  @override
  @JsonKey(name: 'horario_culto')
  String? get horarioCulto;
  @override
  String? get foto;
  @override
  String? get site;
  @override
  @JsonKey(name: 'data_fundacao')
  String? get dataFundacao; // Para as igrejas próximas
  @override
  @JsonKey(name: 'distancia_km')
  double? get distanciaKm;

  /// Create a copy of Igreja
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IgrejaImplCopyWith<_$IgrejaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

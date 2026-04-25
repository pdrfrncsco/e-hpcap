// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distrito.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Distrito _$DistritoFromJson(Map<String, dynamic> json) {
  return _Distrito.fromJson(json);
}

/// @nodoc
mixin _$Distrito {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  Conferencia? get conferencia => throw _privateConstructorUsedError;
  String? get superintendente => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_igrejas')
  int? get totalIgrejas => throw _privateConstructorUsedError;

  /// Serializes this Distrito to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistritoCopyWith<Distrito> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistritoCopyWith<$Res> {
  factory $DistritoCopyWith(Distrito value, $Res Function(Distrito) then) =
      _$DistritoCopyWithImpl<$Res, Distrito>;
  @useResult
  $Res call(
      {int id,
      String nome,
      Conferencia? conferencia,
      String? superintendente,
      @JsonKey(name: 'total_igrejas') int? totalIgrejas});

  $ConferenciaCopyWith<$Res>? get conferencia;
}

/// @nodoc
class _$DistritoCopyWithImpl<$Res, $Val extends Distrito>
    implements $DistritoCopyWith<$Res> {
  _$DistritoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? conferencia = freezed,
    Object? superintendente = freezed,
    Object? totalIgrejas = freezed,
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
      conferencia: freezed == conferencia
          ? _value.conferencia
          : conferencia // ignore: cast_nullable_to_non_nullable
              as Conferencia?,
      superintendente: freezed == superintendente
          ? _value.superintendente
          : superintendente // ignore: cast_nullable_to_non_nullable
              as String?,
      totalIgrejas: freezed == totalIgrejas
          ? _value.totalIgrejas
          : totalIgrejas // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConferenciaCopyWith<$Res>? get conferencia {
    if (_value.conferencia == null) {
      return null;
    }

    return $ConferenciaCopyWith<$Res>(_value.conferencia!, (value) {
      return _then(_value.copyWith(conferencia: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DistritoImplCopyWith<$Res>
    implements $DistritoCopyWith<$Res> {
  factory _$$DistritoImplCopyWith(
          _$DistritoImpl value, $Res Function(_$DistritoImpl) then) =
      __$$DistritoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nome,
      Conferencia? conferencia,
      String? superintendente,
      @JsonKey(name: 'total_igrejas') int? totalIgrejas});

  @override
  $ConferenciaCopyWith<$Res>? get conferencia;
}

/// @nodoc
class __$$DistritoImplCopyWithImpl<$Res>
    extends _$DistritoCopyWithImpl<$Res, _$DistritoImpl>
    implements _$$DistritoImplCopyWith<$Res> {
  __$$DistritoImplCopyWithImpl(
      _$DistritoImpl _value, $Res Function(_$DistritoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? conferencia = freezed,
    Object? superintendente = freezed,
    Object? totalIgrejas = freezed,
  }) {
    return _then(_$DistritoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      conferencia: freezed == conferencia
          ? _value.conferencia
          : conferencia // ignore: cast_nullable_to_non_nullable
              as Conferencia?,
      superintendente: freezed == superintendente
          ? _value.superintendente
          : superintendente // ignore: cast_nullable_to_non_nullable
              as String?,
      totalIgrejas: freezed == totalIgrejas
          ? _value.totalIgrejas
          : totalIgrejas // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistritoImpl extends _Distrito {
  const _$DistritoImpl(
      {required this.id,
      required this.nome,
      this.conferencia,
      this.superintendente,
      @JsonKey(name: 'total_igrejas') this.totalIgrejas})
      : super._();

  factory _$DistritoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistritoImplFromJson(json);

  @override
  final int id;
  @override
  final String nome;
  @override
  final Conferencia? conferencia;
  @override
  final String? superintendente;
  @override
  @JsonKey(name: 'total_igrejas')
  final int? totalIgrejas;

  @override
  String toString() {
    return 'Distrito(id: $id, nome: $nome, conferencia: $conferencia, superintendente: $superintendente, totalIgrejas: $totalIgrejas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistritoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.conferencia, conferencia) ||
                other.conferencia == conferencia) &&
            (identical(other.superintendente, superintendente) ||
                other.superintendente == superintendente) &&
            (identical(other.totalIgrejas, totalIgrejas) ||
                other.totalIgrejas == totalIgrejas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nome, conferencia, superintendente, totalIgrejas);

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistritoImplCopyWith<_$DistritoImpl> get copyWith =>
      __$$DistritoImplCopyWithImpl<_$DistritoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistritoImplToJson(
      this,
    );
  }
}

abstract class _Distrito extends Distrito {
  const factory _Distrito(
          {required final int id,
          required final String nome,
          final Conferencia? conferencia,
          final String? superintendente,
          @JsonKey(name: 'total_igrejas') final int? totalIgrejas}) =
      _$DistritoImpl;
  const _Distrito._() : super._();

  factory _Distrito.fromJson(Map<String, dynamic> json) =
      _$DistritoImpl.fromJson;

  @override
  int get id;
  @override
  String get nome;
  @override
  Conferencia? get conferencia;
  @override
  String? get superintendente;
  @override
  @JsonKey(name: 'total_igrejas')
  int? get totalIgrejas;

  /// Create a copy of Distrito
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistritoImplCopyWith<_$DistritoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'idioma.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Idioma _$IdiomaFromJson(Map<String, dynamic> json) {
  return _Idioma.fromJson(json);
}

/// @nodoc
mixin _$Idioma {
  String get codigo => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_hinos')
  int get totalHinos => throw _privateConstructorUsedError;

  /// Serializes this Idioma to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Idioma
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdiomaCopyWith<Idioma> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdiomaCopyWith<$Res> {
  factory $IdiomaCopyWith(Idioma value, $Res Function(Idioma) then) =
      _$IdiomaCopyWithImpl<$Res, Idioma>;
  @useResult
  $Res call(
      {String codigo,
      String nome,
      @JsonKey(name: 'total_hinos') int totalHinos});
}

/// @nodoc
class _$IdiomaCopyWithImpl<$Res, $Val extends Idioma>
    implements $IdiomaCopyWith<$Res> {
  _$IdiomaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Idioma
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codigo = null,
    Object? nome = null,
    Object? totalHinos = null,
  }) {
    return _then(_value.copyWith(
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      totalHinos: null == totalHinos
          ? _value.totalHinos
          : totalHinos // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdiomaImplCopyWith<$Res> implements $IdiomaCopyWith<$Res> {
  factory _$$IdiomaImplCopyWith(
          _$IdiomaImpl value, $Res Function(_$IdiomaImpl) then) =
      __$$IdiomaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String codigo,
      String nome,
      @JsonKey(name: 'total_hinos') int totalHinos});
}

/// @nodoc
class __$$IdiomaImplCopyWithImpl<$Res>
    extends _$IdiomaCopyWithImpl<$Res, _$IdiomaImpl>
    implements _$$IdiomaImplCopyWith<$Res> {
  __$$IdiomaImplCopyWithImpl(
      _$IdiomaImpl _value, $Res Function(_$IdiomaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Idioma
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codigo = null,
    Object? nome = null,
    Object? totalHinos = null,
  }) {
    return _then(_$IdiomaImpl(
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      totalHinos: null == totalHinos
          ? _value.totalHinos
          : totalHinos // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IdiomaImpl extends _Idioma {
  const _$IdiomaImpl(
      {required this.codigo,
      required this.nome,
      @JsonKey(name: 'total_hinos') required this.totalHinos})
      : super._();

  factory _$IdiomaImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdiomaImplFromJson(json);

  @override
  final String codigo;
  @override
  final String nome;
  @override
  @JsonKey(name: 'total_hinos')
  final int totalHinos;

  @override
  String toString() {
    return 'Idioma(codigo: $codigo, nome: $nome, totalHinos: $totalHinos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdiomaImpl &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.totalHinos, totalHinos) ||
                other.totalHinos == totalHinos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, codigo, nome, totalHinos);

  /// Create a copy of Idioma
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdiomaImplCopyWith<_$IdiomaImpl> get copyWith =>
      __$$IdiomaImplCopyWithImpl<_$IdiomaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IdiomaImplToJson(
      this,
    );
  }
}

abstract class _Idioma extends Idioma {
  const factory _Idioma(
          {required final String codigo,
          required final String nome,
          @JsonKey(name: 'total_hinos') required final int totalHinos}) =
      _$IdiomaImpl;
  const _Idioma._() : super._();

  factory _Idioma.fromJson(Map<String, dynamic> json) = _$IdiomaImpl.fromJson;

  @override
  String get codigo;
  @override
  String get nome;
  @override
  @JsonKey(name: 'total_hinos')
  int get totalHinos;

  /// Create a copy of Idioma
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdiomaImplCopyWith<_$IdiomaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

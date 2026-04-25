// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estrofe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Estrofe _$EstrofeFromJson(Map<String, dynamic> json) {
  return _Estrofe.fromJson(json);
}

/// @nodoc
mixin _$Estrofe {
  int get ordem => throw _privateConstructorUsedError;
  @JsonKey(name: 'numero_no_tipo')
  int? get numeroNoTipo => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  String get texto => throw _privateConstructorUsedError;
  List<String> get versos => throw _privateConstructorUsedError;

  /// Serializes this Estrofe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Estrofe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstrofeCopyWith<Estrofe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstrofeCopyWith<$Res> {
  factory $EstrofeCopyWith(Estrofe value, $Res Function(Estrofe) then) =
      _$EstrofeCopyWithImpl<$Res, Estrofe>;
  @useResult
  $Res call(
      {int ordem,
      @JsonKey(name: 'numero_no_tipo') int? numeroNoTipo,
      String? label,
      String tipo,
      String texto,
      List<String> versos});
}

/// @nodoc
class _$EstrofeCopyWithImpl<$Res, $Val extends Estrofe>
    implements $EstrofeCopyWith<$Res> {
  _$EstrofeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Estrofe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ordem = null,
    Object? numeroNoTipo = freezed,
    Object? label = freezed,
    Object? tipo = null,
    Object? texto = null,
    Object? versos = null,
  }) {
    return _then(_value.copyWith(
      ordem: null == ordem
          ? _value.ordem
          : ordem // ignore: cast_nullable_to_non_nullable
              as int,
      numeroNoTipo: freezed == numeroNoTipo
          ? _value.numeroNoTipo
          : numeroNoTipo // ignore: cast_nullable_to_non_nullable
              as int?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      texto: null == texto
          ? _value.texto
          : texto // ignore: cast_nullable_to_non_nullable
              as String,
      versos: null == versos
          ? _value.versos
          : versos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EstrofeImplCopyWith<$Res> implements $EstrofeCopyWith<$Res> {
  factory _$$EstrofeImplCopyWith(
          _$EstrofeImpl value, $Res Function(_$EstrofeImpl) then) =
      __$$EstrofeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int ordem,
      @JsonKey(name: 'numero_no_tipo') int? numeroNoTipo,
      String? label,
      String tipo,
      String texto,
      List<String> versos});
}

/// @nodoc
class __$$EstrofeImplCopyWithImpl<$Res>
    extends _$EstrofeCopyWithImpl<$Res, _$EstrofeImpl>
    implements _$$EstrofeImplCopyWith<$Res> {
  __$$EstrofeImplCopyWithImpl(
      _$EstrofeImpl _value, $Res Function(_$EstrofeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Estrofe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ordem = null,
    Object? numeroNoTipo = freezed,
    Object? label = freezed,
    Object? tipo = null,
    Object? texto = null,
    Object? versos = null,
  }) {
    return _then(_$EstrofeImpl(
      ordem: null == ordem
          ? _value.ordem
          : ordem // ignore: cast_nullable_to_non_nullable
              as int,
      numeroNoTipo: freezed == numeroNoTipo
          ? _value.numeroNoTipo
          : numeroNoTipo // ignore: cast_nullable_to_non_nullable
              as int?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      texto: null == texto
          ? _value.texto
          : texto // ignore: cast_nullable_to_non_nullable
              as String,
      versos: null == versos
          ? _value._versos
          : versos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EstrofeImpl extends _Estrofe {
  const _$EstrofeImpl(
      {required this.ordem,
      @JsonKey(name: 'numero_no_tipo') this.numeroNoTipo,
      this.label,
      required this.tipo,
      required this.texto,
      required final List<String> versos})
      : _versos = versos,
        super._();

  factory _$EstrofeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstrofeImplFromJson(json);

  @override
  final int ordem;
  @override
  @JsonKey(name: 'numero_no_tipo')
  final int? numeroNoTipo;
  @override
  final String? label;
  @override
  final String tipo;
  @override
  final String texto;
  final List<String> _versos;
  @override
  List<String> get versos {
    if (_versos is EqualUnmodifiableListView) return _versos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_versos);
  }

  @override
  String toString() {
    return 'Estrofe(ordem: $ordem, numeroNoTipo: $numeroNoTipo, label: $label, tipo: $tipo, texto: $texto, versos: $versos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstrofeImpl &&
            (identical(other.ordem, ordem) || other.ordem == ordem) &&
            (identical(other.numeroNoTipo, numeroNoTipo) ||
                other.numeroNoTipo == numeroNoTipo) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.texto, texto) || other.texto == texto) &&
            const DeepCollectionEquality().equals(other._versos, _versos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ordem, numeroNoTipo, label, tipo,
      texto, const DeepCollectionEquality().hash(_versos));

  /// Create a copy of Estrofe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstrofeImplCopyWith<_$EstrofeImpl> get copyWith =>
      __$$EstrofeImplCopyWithImpl<_$EstrofeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstrofeImplToJson(
      this,
    );
  }
}

abstract class _Estrofe extends Estrofe {
  const factory _Estrofe(
      {required final int ordem,
      @JsonKey(name: 'numero_no_tipo') final int? numeroNoTipo,
      final String? label,
      required final String tipo,
      required final String texto,
      required final List<String> versos}) = _$EstrofeImpl;
  const _Estrofe._() : super._();

  factory _Estrofe.fromJson(Map<String, dynamic> json) = _$EstrofeImpl.fromJson;

  @override
  int get ordem;
  @override
  @JsonKey(name: 'numero_no_tipo')
  int? get numeroNoTipo;
  @override
  String? get label;
  @override
  String get tipo;
  @override
  String get texto;
  @override
  List<String> get versos;

  /// Create a copy of Estrofe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstrofeImplCopyWith<_$EstrofeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

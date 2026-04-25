// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conferencia.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conferencia _$ConferenciaFromJson(Map<String, dynamic> json) {
  return _Conferencia.fromJson(json);
}

/// @nodoc
mixin _$Conferencia {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get codigo => throw _privateConstructorUsedError;
  String? get bispo => throw _privateConstructorUsedError;
  String? get sede => throw _privateConstructorUsedError;

  /// Serializes this Conferencia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conferencia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConferenciaCopyWith<Conferencia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConferenciaCopyWith<$Res> {
  factory $ConferenciaCopyWith(
          Conferencia value, $Res Function(Conferencia) then) =
      _$ConferenciaCopyWithImpl<$Res, Conferencia>;
  @useResult
  $Res call({int id, String nome, String codigo, String? bispo, String? sede});
}

/// @nodoc
class _$ConferenciaCopyWithImpl<$Res, $Val extends Conferencia>
    implements $ConferenciaCopyWith<$Res> {
  _$ConferenciaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conferencia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? codigo = null,
    Object? bispo = freezed,
    Object? sede = freezed,
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
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      bispo: freezed == bispo
          ? _value.bispo
          : bispo // ignore: cast_nullable_to_non_nullable
              as String?,
      sede: freezed == sede
          ? _value.sede
          : sede // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConferenciaImplCopyWith<$Res>
    implements $ConferenciaCopyWith<$Res> {
  factory _$$ConferenciaImplCopyWith(
          _$ConferenciaImpl value, $Res Function(_$ConferenciaImpl) then) =
      __$$ConferenciaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nome, String codigo, String? bispo, String? sede});
}

/// @nodoc
class __$$ConferenciaImplCopyWithImpl<$Res>
    extends _$ConferenciaCopyWithImpl<$Res, _$ConferenciaImpl>
    implements _$$ConferenciaImplCopyWith<$Res> {
  __$$ConferenciaImplCopyWithImpl(
      _$ConferenciaImpl _value, $Res Function(_$ConferenciaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conferencia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? codigo = null,
    Object? bispo = freezed,
    Object? sede = freezed,
  }) {
    return _then(_$ConferenciaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      bispo: freezed == bispo
          ? _value.bispo
          : bispo // ignore: cast_nullable_to_non_nullable
              as String?,
      sede: freezed == sede
          ? _value.sede
          : sede // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConferenciaImpl extends _Conferencia {
  const _$ConferenciaImpl(
      {required this.id,
      required this.nome,
      required this.codigo,
      this.bispo,
      this.sede})
      : super._();

  factory _$ConferenciaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConferenciaImplFromJson(json);

  @override
  final int id;
  @override
  final String nome;
  @override
  final String codigo;
  @override
  final String? bispo;
  @override
  final String? sede;

  @override
  String toString() {
    return 'Conferencia(id: $id, nome: $nome, codigo: $codigo, bispo: $bispo, sede: $sede)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConferenciaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.bispo, bispo) || other.bispo == bispo) &&
            (identical(other.sede, sede) || other.sede == sede));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nome, codigo, bispo, sede);

  /// Create a copy of Conferencia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConferenciaImplCopyWith<_$ConferenciaImpl> get copyWith =>
      __$$ConferenciaImplCopyWithImpl<_$ConferenciaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConferenciaImplToJson(
      this,
    );
  }
}

abstract class _Conferencia extends Conferencia {
  const factory _Conferencia(
      {required final int id,
      required final String nome,
      required final String codigo,
      final String? bispo,
      final String? sede}) = _$ConferenciaImpl;
  const _Conferencia._() : super._();

  factory _Conferencia.fromJson(Map<String, dynamic> json) =
      _$ConferenciaImpl.fromJson;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get codigo;
  @override
  String? get bispo;
  @override
  String? get sede;

  /// Create a copy of Conferencia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConferenciaImplCopyWith<_$ConferenciaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

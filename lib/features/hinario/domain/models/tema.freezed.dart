// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tema _$TemaFromJson(Map<String, dynamic> json) {
  return _Tema.fromJson(json);
}

/// @nodoc
mixin _$Tema {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  /// Serializes this Tema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemaCopyWith<Tema> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemaCopyWith<$Res> {
  factory $TemaCopyWith(Tema value, $Res Function(Tema) then) =
      _$TemaCopyWithImpl<$Res, Tema>;
  @useResult
  $Res call({int id, String nome, String slug});
}

/// @nodoc
class _$TemaCopyWithImpl<$Res, $Val extends Tema>
    implements $TemaCopyWith<$Res> {
  _$TemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? slug = null,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemaImplCopyWith<$Res> implements $TemaCopyWith<$Res> {
  factory _$$TemaImplCopyWith(
          _$TemaImpl value, $Res Function(_$TemaImpl) then) =
      __$$TemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nome, String slug});
}

/// @nodoc
class __$$TemaImplCopyWithImpl<$Res>
    extends _$TemaCopyWithImpl<$Res, _$TemaImpl>
    implements _$$TemaImplCopyWith<$Res> {
  __$$TemaImplCopyWithImpl(_$TemaImpl _value, $Res Function(_$TemaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? slug = null,
  }) {
    return _then(_$TemaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nome: null == nome
          ? _value.nome
          : nome // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemaImpl extends _Tema {
  const _$TemaImpl({required this.id, required this.nome, required this.slug})
      : super._();

  factory _$TemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemaImplFromJson(json);

  @override
  final int id;
  @override
  final String nome;
  @override
  final String slug;

  @override
  String toString() {
    return 'Tema(id: $id, nome: $nome, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nome, slug);

  /// Create a copy of Tema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemaImplCopyWith<_$TemaImpl> get copyWith =>
      __$$TemaImplCopyWithImpl<_$TemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemaImplToJson(
      this,
    );
  }
}

abstract class _Tema extends Tema {
  const factory _Tema(
      {required final int id,
      required final String nome,
      required final String slug}) = _$TemaImpl;
  const _Tema._() : super._();

  factory _Tema.fromJson(Map<String, dynamic> json) = _$TemaImpl.fromJson;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get slug;

  /// Create a copy of Tema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemaImplCopyWith<_$TemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

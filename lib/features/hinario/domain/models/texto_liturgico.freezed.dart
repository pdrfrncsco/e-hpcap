// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'texto_liturgico.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TextoLiturgico _$TextoLiturgicoFromJson(Map<String, dynamic> json) {
  return _TextoLiturgico.fromJson(json);
}

/// @nodoc
mixin _$TextoLiturgico {
  int get id => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_display')
  String get tipoDisplay => throw _privateConstructorUsedError;
  String? get idioma => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get conteudo => throw _privateConstructorUsedError;
  int get ordem => throw _privateConstructorUsedError;

  /// Serializes this TextoLiturgico to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TextoLiturgico
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextoLiturgicoCopyWith<TextoLiturgico> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextoLiturgicoCopyWith<$Res> {
  factory $TextoLiturgicoCopyWith(
          TextoLiturgico value, $Res Function(TextoLiturgico) then) =
      _$TextoLiturgicoCopyWithImpl<$Res, TextoLiturgico>;
  @useResult
  $Res call(
      {int id,
      String tipo,
      @JsonKey(name: 'tipo_display') String tipoDisplay,
      String? idioma,
      String titulo,
      String conteudo,
      int ordem});
}

/// @nodoc
class _$TextoLiturgicoCopyWithImpl<$Res, $Val extends TextoLiturgico>
    implements $TextoLiturgicoCopyWith<$Res> {
  _$TextoLiturgicoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextoLiturgico
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tipo = null,
    Object? tipoDisplay = null,
    Object? idioma = freezed,
    Object? titulo = null,
    Object? conteudo = null,
    Object? ordem = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      tipoDisplay: null == tipoDisplay
          ? _value.tipoDisplay
          : tipoDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      idioma: freezed == idioma
          ? _value.idioma
          : idioma // ignore: cast_nullable_to_non_nullable
              as String?,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      conteudo: null == conteudo
          ? _value.conteudo
          : conteudo // ignore: cast_nullable_to_non_nullable
              as String,
      ordem: null == ordem
          ? _value.ordem
          : ordem // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextoLiturgicoImplCopyWith<$Res>
    implements $TextoLiturgicoCopyWith<$Res> {
  factory _$$TextoLiturgicoImplCopyWith(_$TextoLiturgicoImpl value,
          $Res Function(_$TextoLiturgicoImpl) then) =
      __$$TextoLiturgicoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String tipo,
      @JsonKey(name: 'tipo_display') String tipoDisplay,
      String? idioma,
      String titulo,
      String conteudo,
      int ordem});
}

/// @nodoc
class __$$TextoLiturgicoImplCopyWithImpl<$Res>
    extends _$TextoLiturgicoCopyWithImpl<$Res, _$TextoLiturgicoImpl>
    implements _$$TextoLiturgicoImplCopyWith<$Res> {
  __$$TextoLiturgicoImplCopyWithImpl(
      _$TextoLiturgicoImpl _value, $Res Function(_$TextoLiturgicoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TextoLiturgico
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tipo = null,
    Object? tipoDisplay = null,
    Object? idioma = freezed,
    Object? titulo = null,
    Object? conteudo = null,
    Object? ordem = null,
  }) {
    return _then(_$TextoLiturgicoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      tipoDisplay: null == tipoDisplay
          ? _value.tipoDisplay
          : tipoDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      idioma: freezed == idioma
          ? _value.idioma
          : idioma // ignore: cast_nullable_to_non_nullable
              as String?,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      conteudo: null == conteudo
          ? _value.conteudo
          : conteudo // ignore: cast_nullable_to_non_nullable
              as String,
      ordem: null == ordem
          ? _value.ordem
          : ordem // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextoLiturgicoImpl implements _TextoLiturgico {
  const _$TextoLiturgicoImpl(
      {required this.id,
      required this.tipo,
      @JsonKey(name: 'tipo_display') required this.tipoDisplay,
      this.idioma,
      required this.titulo,
      required this.conteudo,
      this.ordem = 1});

  factory _$TextoLiturgicoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextoLiturgicoImplFromJson(json);

  @override
  final int id;
  @override
  final String tipo;
  @override
  @JsonKey(name: 'tipo_display')
  final String tipoDisplay;
  @override
  final String? idioma;
  @override
  final String titulo;
  @override
  final String conteudo;
  @override
  @JsonKey()
  final int ordem;

  @override
  String toString() {
    return 'TextoLiturgico(id: $id, tipo: $tipo, tipoDisplay: $tipoDisplay, idioma: $idioma, titulo: $titulo, conteudo: $conteudo, ordem: $ordem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextoLiturgicoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.tipoDisplay, tipoDisplay) ||
                other.tipoDisplay == tipoDisplay) &&
            (identical(other.idioma, idioma) || other.idioma == idioma) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.conteudo, conteudo) ||
                other.conteudo == conteudo) &&
            (identical(other.ordem, ordem) || other.ordem == ordem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tipo, tipoDisplay, idioma, titulo, conteudo, ordem);

  /// Create a copy of TextoLiturgico
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextoLiturgicoImplCopyWith<_$TextoLiturgicoImpl> get copyWith =>
      __$$TextoLiturgicoImplCopyWithImpl<_$TextoLiturgicoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TextoLiturgicoImplToJson(
      this,
    );
  }
}

abstract class _TextoLiturgico implements TextoLiturgico {
  const factory _TextoLiturgico(
      {required final int id,
      required final String tipo,
      @JsonKey(name: 'tipo_display') required final String tipoDisplay,
      final String? idioma,
      required final String titulo,
      required final String conteudo,
      final int ordem}) = _$TextoLiturgicoImpl;

  factory _TextoLiturgico.fromJson(Map<String, dynamic> json) =
      _$TextoLiturgicoImpl.fromJson;

  @override
  int get id;
  @override
  String get tipo;
  @override
  @JsonKey(name: 'tipo_display')
  String get tipoDisplay;
  @override
  String? get idioma;
  @override
  String get titulo;
  @override
  String get conteudo;
  @override
  int get ordem;

  /// Create a copy of TextoLiturgico
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextoLiturgicoImplCopyWith<_$TextoLiturgicoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

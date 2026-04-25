// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hino.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Hino _$HinoFromJson(Map<String, dynamic> json) {
  return _Hino.fromJson(json);
}

/// @nodoc
mixin _$Hino {
  int get id => throw _privateConstructorUsedError;
  String get secao => throw _privateConstructorUsedError;
  int get numero => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  List<Tema> get temas => throw _privateConstructorUsedError;
  Idioma? get idioma => throw _privateConstructorUsedError;
  String? get referencia => throw _privateConstructorUsedError;
  List<Estrofe>? get estrofes => throw _privateConstructorUsedError;
  @JsonKey(name: 'letra_de')
  String? get letraDe => throw _privateConstructorUsedError;
  @JsonKey(name: 'musica_de')
  String? get musicaDe => throw _privateConstructorUsedError;

  /// Serializes this Hino to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HinoCopyWith<Hino> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HinoCopyWith<$Res> {
  factory $HinoCopyWith(Hino value, $Res Function(Hino) then) =
      _$HinoCopyWithImpl<$Res, Hino>;
  @useResult
  $Res call(
      {int id,
      String secao,
      int numero,
      String titulo,
      List<Tema> temas,
      Idioma? idioma,
      String? referencia,
      List<Estrofe>? estrofes,
      @JsonKey(name: 'letra_de') String? letraDe,
      @JsonKey(name: 'musica_de') String? musicaDe});

  $IdiomaCopyWith<$Res>? get idioma;
}

/// @nodoc
class _$HinoCopyWithImpl<$Res, $Val extends Hino>
    implements $HinoCopyWith<$Res> {
  _$HinoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? secao = null,
    Object? numero = null,
    Object? titulo = null,
    Object? temas = null,
    Object? idioma = freezed,
    Object? referencia = freezed,
    Object? estrofes = freezed,
    Object? letraDe = freezed,
    Object? musicaDe = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      secao: null == secao
          ? _value.secao
          : secao // ignore: cast_nullable_to_non_nullable
              as String,
      numero: null == numero
          ? _value.numero
          : numero // ignore: cast_nullable_to_non_nullable
              as int,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      temas: null == temas
          ? _value.temas
          : temas // ignore: cast_nullable_to_non_nullable
              as List<Tema>,
      idioma: freezed == idioma
          ? _value.idioma
          : idioma // ignore: cast_nullable_to_non_nullable
              as Idioma?,
      referencia: freezed == referencia
          ? _value.referencia
          : referencia // ignore: cast_nullable_to_non_nullable
              as String?,
      estrofes: freezed == estrofes
          ? _value.estrofes
          : estrofes // ignore: cast_nullable_to_non_nullable
              as List<Estrofe>?,
      letraDe: freezed == letraDe
          ? _value.letraDe
          : letraDe // ignore: cast_nullable_to_non_nullable
              as String?,
      musicaDe: freezed == musicaDe
          ? _value.musicaDe
          : musicaDe // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IdiomaCopyWith<$Res>? get idioma {
    if (_value.idioma == null) {
      return null;
    }

    return $IdiomaCopyWith<$Res>(_value.idioma!, (value) {
      return _then(_value.copyWith(idioma: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HinoImplCopyWith<$Res> implements $HinoCopyWith<$Res> {
  factory _$$HinoImplCopyWith(
          _$HinoImpl value, $Res Function(_$HinoImpl) then) =
      __$$HinoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String secao,
      int numero,
      String titulo,
      List<Tema> temas,
      Idioma? idioma,
      String? referencia,
      List<Estrofe>? estrofes,
      @JsonKey(name: 'letra_de') String? letraDe,
      @JsonKey(name: 'musica_de') String? musicaDe});

  @override
  $IdiomaCopyWith<$Res>? get idioma;
}

/// @nodoc
class __$$HinoImplCopyWithImpl<$Res>
    extends _$HinoCopyWithImpl<$Res, _$HinoImpl>
    implements _$$HinoImplCopyWith<$Res> {
  __$$HinoImplCopyWithImpl(_$HinoImpl _value, $Res Function(_$HinoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? secao = null,
    Object? numero = null,
    Object? titulo = null,
    Object? temas = null,
    Object? idioma = freezed,
    Object? referencia = freezed,
    Object? estrofes = freezed,
    Object? letraDe = freezed,
    Object? musicaDe = freezed,
  }) {
    return _then(_$HinoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      secao: null == secao
          ? _value.secao
          : secao // ignore: cast_nullable_to_non_nullable
              as String,
      numero: null == numero
          ? _value.numero
          : numero // ignore: cast_nullable_to_non_nullable
              as int,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      temas: null == temas
          ? _value._temas
          : temas // ignore: cast_nullable_to_non_nullable
              as List<Tema>,
      idioma: freezed == idioma
          ? _value.idioma
          : idioma // ignore: cast_nullable_to_non_nullable
              as Idioma?,
      referencia: freezed == referencia
          ? _value.referencia
          : referencia // ignore: cast_nullable_to_non_nullable
              as String?,
      estrofes: freezed == estrofes
          ? _value._estrofes
          : estrofes // ignore: cast_nullable_to_non_nullable
              as List<Estrofe>?,
      letraDe: freezed == letraDe
          ? _value.letraDe
          : letraDe // ignore: cast_nullable_to_non_nullable
              as String?,
      musicaDe: freezed == musicaDe
          ? _value.musicaDe
          : musicaDe // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HinoImpl extends _Hino {
  const _$HinoImpl(
      {required this.id,
      required this.secao,
      required this.numero,
      required this.titulo,
      final List<Tema> temas = const [],
      this.idioma,
      this.referencia,
      final List<Estrofe>? estrofes,
      @JsonKey(name: 'letra_de') this.letraDe,
      @JsonKey(name: 'musica_de') this.musicaDe})
      : _temas = temas,
        _estrofes = estrofes,
        super._();

  factory _$HinoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HinoImplFromJson(json);

  @override
  final int id;
  @override
  final String secao;
  @override
  final int numero;
  @override
  final String titulo;
  final List<Tema> _temas;
  @override
  @JsonKey()
  List<Tema> get temas {
    if (_temas is EqualUnmodifiableListView) return _temas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_temas);
  }

  @override
  final Idioma? idioma;
  @override
  final String? referencia;
  final List<Estrofe>? _estrofes;
  @override
  List<Estrofe>? get estrofes {
    final value = _estrofes;
    if (value == null) return null;
    if (_estrofes is EqualUnmodifiableListView) return _estrofes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'letra_de')
  final String? letraDe;
  @override
  @JsonKey(name: 'musica_de')
  final String? musicaDe;

  @override
  String toString() {
    return 'Hino(id: $id, secao: $secao, numero: $numero, titulo: $titulo, temas: $temas, idioma: $idioma, referencia: $referencia, estrofes: $estrofes, letraDe: $letraDe, musicaDe: $musicaDe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HinoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.secao, secao) || other.secao == secao) &&
            (identical(other.numero, numero) || other.numero == numero) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            const DeepCollectionEquality().equals(other._temas, _temas) &&
            (identical(other.idioma, idioma) || other.idioma == idioma) &&
            (identical(other.referencia, referencia) ||
                other.referencia == referencia) &&
            const DeepCollectionEquality().equals(other._estrofes, _estrofes) &&
            (identical(other.letraDe, letraDe) || other.letraDe == letraDe) &&
            (identical(other.musicaDe, musicaDe) ||
                other.musicaDe == musicaDe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      secao,
      numero,
      titulo,
      const DeepCollectionEquality().hash(_temas),
      idioma,
      referencia,
      const DeepCollectionEquality().hash(_estrofes),
      letraDe,
      musicaDe);

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HinoImplCopyWith<_$HinoImpl> get copyWith =>
      __$$HinoImplCopyWithImpl<_$HinoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HinoImplToJson(
      this,
    );
  }
}

abstract class _Hino extends Hino {
  const factory _Hino(
      {required final int id,
      required final String secao,
      required final int numero,
      required final String titulo,
      final List<Tema> temas,
      final Idioma? idioma,
      final String? referencia,
      final List<Estrofe>? estrofes,
      @JsonKey(name: 'letra_de') final String? letraDe,
      @JsonKey(name: 'musica_de') final String? musicaDe}) = _$HinoImpl;
  const _Hino._() : super._();

  factory _Hino.fromJson(Map<String, dynamic> json) = _$HinoImpl.fromJson;

  @override
  int get id;
  @override
  String get secao;
  @override
  int get numero;
  @override
  String get titulo;
  @override
  List<Tema> get temas;
  @override
  Idioma? get idioma;
  @override
  String? get referencia;
  @override
  List<Estrofe>? get estrofes;
  @override
  @JsonKey(name: 'letra_de')
  String? get letraDe;
  @override
  @JsonKey(name: 'musica_de')
  String? get musicaDe;

  /// Create a copy of Hino
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HinoImplCopyWith<_$HinoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

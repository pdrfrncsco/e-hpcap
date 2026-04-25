import 'package:freezed_annotation/freezed_annotation.dart';
import 'tema.dart';
import 'idioma.dart';
import 'estrofe.dart';

part 'hino.freezed.dart';
part 'hino.g.dart';

@freezed
abstract class Hino with _$Hino {
  const Hino._();

  const factory Hino({
    required int id,
    required String secao,
    required int numero,
    required String titulo,
    @Default([]) List<Tema> temas,

    Idioma? idioma,
    String? referencia,
    List<Estrofe>? estrofes,
    @JsonKey(name: 'letra_de') String? letraDe,
    @JsonKey(name: 'musica_de') String? musicaDe,
  }) = _Hino;

  factory Hino.fromJson(Map<String, dynamic> json) => _$HinoFromJson(json);
}

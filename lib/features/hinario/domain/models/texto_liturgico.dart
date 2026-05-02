import 'package:freezed_annotation/freezed_annotation.dart';

part 'texto_liturgico.freezed.dart';
part 'texto_liturgico.g.dart';

@freezed
class TextoLiturgico with _$TextoLiturgico {
  const factory TextoLiturgico({
    required int id,
    required String tipo,
    @JsonKey(name: 'tipo_display') required String tipoDisplay,
    String? idioma,
    required String titulo,
    required String conteudo,
    @Default(1) int ordem,
  }) = _TextoLiturgico;

  factory TextoLiturgico.fromJson(Map<String, dynamic> json) =>
      _$TextoLiturgicoFromJson(json);
}

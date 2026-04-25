import 'package:freezed_annotation/freezed_annotation.dart';

part 'estrofe.freezed.dart';
part 'estrofe.g.dart';

@freezed
abstract class Estrofe with _$Estrofe {
  const Estrofe._();

  const factory Estrofe({
    required int ordem,
    @JsonKey(name: 'numero_no_tipo') int? numeroNoTipo,
    String? label,
    required String tipo,
    required String texto,
    required List<String> versos,
  }) = _Estrofe;

  factory Estrofe.fromJson(Map<String, dynamic> json) =>
      _$EstrofeFromJson(json);
}

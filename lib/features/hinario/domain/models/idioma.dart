import 'package:freezed_annotation/freezed_annotation.dart';

part 'idioma.freezed.dart';
part 'idioma.g.dart';

@freezed
abstract class Idioma with _$Idioma {
  const Idioma._();

  const factory Idioma({
    required String codigo,
    required String nome,
    @JsonKey(name: 'total_hinos') required int totalHinos,
  }) = _Idioma;

  factory Idioma.fromJson(Map<String, dynamic> json) => _$IdiomaFromJson(json);
}

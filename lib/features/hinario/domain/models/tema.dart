import 'package:freezed_annotation/freezed_annotation.dart';

part 'tema.freezed.dart';
part 'tema.g.dart';

@freezed
abstract class Tema with _$Tema {
  const Tema._();

  const factory Tema({
    required int id,
    required String nome,
    required String slug,
  }) = _Tema;

  factory Tema.fromJson(Map<String, dynamic> json) => _$TemaFromJson(json);
}

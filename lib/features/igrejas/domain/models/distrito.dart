import 'package:freezed_annotation/freezed_annotation.dart';
import 'conferencia.dart';

part 'distrito.freezed.dart';
part 'distrito.g.dart';

@freezed
abstract class Distrito with _$Distrito {
  const Distrito._();

  const factory Distrito({
    required int id,
    required String nome,
    Conferencia? conferencia,
    String? superintendente,
    @JsonKey(name: 'total_igrejas') int? totalIgrejas,
  }) = _Distrito;

  factory Distrito.fromJson(Map<String, dynamic> json) =>
      _$DistritoFromJson(json);
}

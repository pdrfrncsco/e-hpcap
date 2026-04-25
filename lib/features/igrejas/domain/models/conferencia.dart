import 'package:freezed_annotation/freezed_annotation.dart';

part 'conferencia.freezed.dart';
part 'conferencia.g.dart';

@freezed
abstract class Conferencia with _$Conferencia {
  const Conferencia._();

  const factory Conferencia({
    required int id,
    required String nome,
    required String codigo,
    String? bispo,
    String? sede,
  }) = _Conferencia;

  factory Conferencia.fromJson(Map<String, dynamic> json) =>
      _$ConferenciaFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'distrito.dart';

part 'igreja.freezed.dart';
part 'igreja.g.dart';

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final normalized = value.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }
  return null;
}

@freezed
abstract class Igreja with _$Igreja {
  const Igreja._();

  const factory Igreja({
    required int id,
    required String nome,
    required String pastor,
    required String cidade,

    // Na listagem podemos receber apenas o nome do distrito e codigo da conf
    @JsonKey(name: 'distrito_nome') String? distritoNome,
    @JsonKey(name: 'conferencia_codigo') String? conferenciaCodigo,

    // No detalhe recebemos o objeto completo do distrito
    Distrito? distrito,

    String? kuid,
    String? provincia,
    String? morada,
    @JsonKey(fromJson: _parseDouble) double? latitude,
    @JsonKey(fromJson: _parseDouble) double? longitude,
    String? telefone,
    String? email,
    @JsonKey(name: 'horario_culto') String? horarioCulto,
    String? foto,
    String? site,
    @JsonKey(name: 'data_fundacao') String? dataFundacao,
    
    // Para as igrejas próximas
    @JsonKey(name: 'distancia_km') double? distanciaKm,
  }) = _Igreja;

  factory Igreja.fromJson(Map<String, dynamic> json) => _$IgrejaFromJson(json);
}

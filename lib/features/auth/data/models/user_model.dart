import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('membro')
  membro,
  @JsonValue('igreja')
  igreja,
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    String? email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required UserRole role,
    String? telefone,
    String? biografia,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

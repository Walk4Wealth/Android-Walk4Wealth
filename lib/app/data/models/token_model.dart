import '../../domain/entity/token.dart';

class TokenModel extends Token {
  const TokenModel({required super.token});

  Map<String, dynamic> toLocal() {
    return {'token': token};
  }

  factory TokenModel.fromLocal(Map<String, dynamic> map) {
    return TokenModel(token: map['token']);
  }

  factory TokenModel.fromRemote(Map<String, dynamic> map) {
    final data = map['data'];
    return TokenModel(token: data['token']);
  }
}

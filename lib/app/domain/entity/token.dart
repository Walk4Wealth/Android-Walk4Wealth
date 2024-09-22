import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String token;

  const Token({required this.token});

  @override
  List<Object?> get props => [token];
}

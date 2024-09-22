import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? nama;
  final String? imgProfile;
  final int? age;
  final int? noTelp;
  final int weight;
  final int height;
  final int? totalPoints;
  final String role;
  final String level;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.nama,
    required this.imgProfile,
    required this.age,
    required this.noTelp,
    required this.weight,
    required this.height,
    required this.totalPoints,
    required this.role,
    required this.level,
  });

  @override
  List<Object?> get props {
    return [
      id,
      username,
      email,
      nama,
      imgProfile,
      age,
      noTelp,
      weight,
      height,
      totalPoints,
      role,
      level,
    ];
  }
}

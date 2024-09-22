import '../../domain/entity/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.nama,
    required super.imgProfile,
    required super.age,
    required super.noTelp,
    required super.weight,
    required super.height,
    required super.totalPoints,
    required super.role,
    required super.level,
  });

  Map<String, dynamic> toLocal() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'nama': nama,
      'profile_img': imgProfile,
      'age': age,
      'no_telp': noTelp,
      'weight': weight,
      'height': height,
      'total_points': totalPoints,
      'role': role,
      'level': level,
    };
  }

  factory UserModel.fromLocal(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      nama: json['nama'],
      imgProfile: json['profile_img'],
      age: json['age'],
      noTelp: json['no_telp'],
      weight: json['weight'],
      height: json['height'],
      totalPoints: json['total_points'],
      role: json['role'],
      level: json['level'],
    );
  }

  factory UserModel.fromRemote(Map<String, dynamic> json) {
    final data = json['data'];
    return UserModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      nama: data['nama'],
      imgProfile: data['profile_img'],
      age: data['age'],
      noTelp: data['no_telp'],
      weight: data['weight'],
      height: data['height'],
      totalPoints: data['total_points'],
      role: data['role'],
      level: data['level'],
    );
  }
}

import 'package:chato/src/features/auth/domain/entities/user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      photoUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': photoUrl,
    };
  }
}

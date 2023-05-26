import 'package:usersappv/features/users/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    int? id,
    required String username,
    required String email,
    required String name,
    required String lastName,
  }) : super(
          id: id,
          username: username,
          email: email,
          name: name,
          lastName: lastName,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
    );
  }
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? name,
    String? lastName,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      name: user.name,
      lastName: user.lastName,
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'last_name': lastName,
    };
  }
}

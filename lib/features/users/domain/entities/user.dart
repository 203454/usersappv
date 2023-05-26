class User {
  final int? id;
  final String username;
  final String email;
  final String name;
  final String lastName;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.lastName,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'last_name': lastName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'last_name': lastName,
    };
  }
}

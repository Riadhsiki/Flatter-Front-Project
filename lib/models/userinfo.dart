class UserInfo {
  final String id;
  final String username;
  final List<String> roles;

  UserInfo({
    required this.id,
    required this.username,
    required this.roles,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      username: json['username'] as String,
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}
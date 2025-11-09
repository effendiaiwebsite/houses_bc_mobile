import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String role;
  final String? name;
  final bool verified;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.name,
    required this.verified,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String? ?? 'client',
      name: json['name'] as String?,
      verified: json['verified'] as bool? ?? false,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
      'name': name,
      'verified': verified,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? phoneNumber,
    String? role,
    String? name,
    bool? verified,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      name: name ?? this.name,
      verified: verified ?? this.verified,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [id, phoneNumber, role, name, verified, lastLogin];
}

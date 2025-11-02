class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role; // 'user', 'organizer', 'admin'
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.role = 'user',
    this.createdAt,
  });

  // Computed properties
  bool get isOrganizer => role == 'organizer' || role == 'admin';
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

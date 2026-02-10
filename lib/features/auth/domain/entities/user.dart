class User {
  final String id;
  final String rollNumber;
  final String email;
  final String? name;
  final String role;
  final String? department;
  final String? year;
  final bool isEmailVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.rollNumber,
    required this.email,
    this.name,
    required this.role,
    this.department,
    this.year,
    required this.isEmailVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      rollNumber: json['rollNumber'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      role: json['role'] as String,
      department: json['department'] as String?,
      year: json['year'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': rollNumber,
      'email': email,
      'name': name,
      'role': role,
      'department': department,
      'year': year,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? rollNumber,
    String? email,
    String? name,
    String? role,
    String? department,
    String? year,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      rollNumber: rollNumber ?? this.rollNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      year: year ?? this.year,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

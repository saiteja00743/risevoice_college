class Grievance {
  final String id;
  final String? userId; // null if anonymous
  final String title;
  final String description;
  final String category;
  final String status;
  final String priority;
  final bool isAnonymous;
  final List<String> attachments;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final List<GrievanceUpdate> updates;

  Grievance({
    required this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.isAnonymous,
    this.attachments = const [],
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.updates = const [],
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      assignedTo: json['assignedTo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
      updates: (json['updates'] as List<dynamic>?)
              ?.map((e) => GrievanceUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'isAnonymous': isAnonymous,
      'attachments': attachments,
      'assignedTo': assignedTo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'updates': updates.map((e) => e.toJson()).toList(),
    };
  }

  Grievance copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    bool? isAnonymous,
    List<String>? attachments,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    List<GrievanceUpdate>? updates,
  }) {
    return Grievance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      attachments: attachments ?? this.attachments,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      updates: updates ?? this.updates,
    );
  }
}

class GrievanceUpdate {
  final String id;
  final String grievanceId;
  final String message;
  final String updatedBy;
  final String? updatedByRole;
  final DateTime createdAt;

  GrievanceUpdate({
    required this.id,
    required this.grievanceId,
    required this.message,
    required this.updatedBy,
    this.updatedByRole,
    required this.createdAt,
  });

  factory GrievanceUpdate.fromJson(Map<String, dynamic> json) {
    return GrievanceUpdate(
      id: json['id'] as String,
      grievanceId: json['grievanceId'] as String,
      message: json['message'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedByRole: json['updatedByRole'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grievanceId': grievanceId,
      'message': message,
      'updatedBy': updatedBy,
      'updatedByRole': updatedByRole,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

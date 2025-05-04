class Task {
  final int id;
  final String name;
  final String description;
  final String status;
  final String priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    String? status,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

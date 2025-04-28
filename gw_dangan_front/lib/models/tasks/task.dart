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
}

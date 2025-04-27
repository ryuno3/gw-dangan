class Task {
  final int id; // タスクを一意に識別するためのID
  final String name; // タスクのタイトル
  final String description; // タスクの詳細（オプション）
  final String status; // タスクの状態（例: "TODO", "IN_PROGRESS", "DONE"）
  final String priority; // タスクの優先度（例: "HIGH", "MEDIUM", "LOW"）
  final bool isCompleted; // 完了フラグ

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.status = 'TODO', // デフォルト値として'TODO'を設定
    this.priority = 'MEDIUM', // デフォルト値として'MEDIUM'を設定
    this.isCompleted = false, // デフォルト値としてfalseを設定
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],

      // JSONから取得した値がnullの場合はデフォルト値を使用
      status: json['status'] ?? 'TODO',
      priority: json['priority'] ?? 'MEDIUM',
      isCompleted: json['isCompleted'] ?? false,
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

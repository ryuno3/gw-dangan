import 'package:http/http.dart';

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

  // JSONからTaskを生成するファクトリメソッド - null安全性を強化
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      name: json['title'] ??
          json['name'] ??
          '無題のタスク', // title または name フィールドを受け入れる
      description: json['description'] ?? '',
      // JSONから取得した値がnullの場合はデフォルト値を使用
      status: json['status'] ?? 'TODO',
      priority: json['priority'] ?? 'MEDIUM',
      isCompleted: json['isCompleted'] ??
          json['completed'] ??
          false, // isCompleted または completed フィールドを受け入れる
    );
  }

  // TaskをJSON形式に変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name, // APIが期待するフィールド名に合わせる
      'description': description,
      'status': status,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}

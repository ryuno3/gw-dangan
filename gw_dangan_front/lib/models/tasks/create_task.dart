import 'package:gw_dangan/models/tasks/task.dart';

class CreateTaskDto {
  final String name;
  final String description;

  final String authorId;


  CreateTaskDto({
    required this.name,
    required this.description,
    required this.authorId,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'authorId': authorId,
    };
  }

  // Taskオブジェクトに変換するメソッド
  Task toTask() {
    return Task(
      id: 9999, // IDはサーバーから取得するため、ここでは仮の値を設定
      name: name,
      description: description,
      status: 'TODO', // デフォルトのステータスを設定
      priority: 'NORMAL', // デフォルトの優先度を設定
      isCompleted: false, // 新規作成時は未完了とする
    );
  }
}

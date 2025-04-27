import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:http/http.dart' as http;

// Future<List<Task>> fetchAllTasks() async {
//   final response = await http.get(Uri.parse('http://localhost:8080/api/tasks'));
//   if (response.statusCode == 200) {
//     // JSONレスポンスをリストとしてデコード
//     final List<dynamic> tasksJson = jsonDecode(response.body);
//     // 各JSONオブジェクトをTaskオブジェクトに変換
//     return tasksJson.map((json) => Task.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load tasks');
//   }
// }

class TaskRepository {
  final String baseUrl;

  TaskRepository({this.baseUrl = 'http://localhost:8080/api'});

  Future<List<Task>> fetchAllTasks() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tasks'));

      if (res.statusCode == 200) {
        final List<dynamic> tasksJson = jsonDecode(res.body);
        return tasksJson.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('タスクの取得に失敗しました: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('fetchでのエラー: $e');
      throw Exception('サーバー通信中にエラーが発生しました: $e');
    }
  }
}

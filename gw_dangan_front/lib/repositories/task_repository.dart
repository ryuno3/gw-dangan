import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gw_dangan/models/tasks/create_task.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl;

  TaskRepository({this.baseUrl = 'http://localhost:8080/api/tasks'});

  Future<List<Task>> fetchAllTasks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

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

  Future<void> createTask(CreateTaskDto params) async {
    try {
      final res = await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'}, body: params.toJson());
      if (res.statusCode != 201) {
        debugPrint('[Repository]create時ステータスコード: ${res.statusCode}');

        // 201 Createdは成功を示すため、他のステータスコードはエラーとみなす
        throw Exception('タスクの作成に失敗しました: ${res.statusCode}');
      }

      // タスクの作成に成功した場合、何も返さない(この責務はproviderに)
    } catch (e) {
      debugPrint('[Repository]create:trycatchでのエラー: $e');
      throw Exception('サーバー通信中にエラーが発生しました: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      if (res.statusCode != 204) {
        debugPrint('[Repository]delete時ステータスコード: ${res.statusCode}');

        // 204 No Contentは成功を示すため、他のステータスコードはエラーとみなす
        throw Exception('タスクの削除に失敗しました: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('[Repository]delete:trycatchでのエラー: $e');
      throw Exception('サーバー通信中にエラーが発生しました: $e');
    }
  }
}

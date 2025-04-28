import 'dart:convert';
// debugPrint用
// import 'package:flutter/material.dart';
import 'package:gw_dangan/models/tasks/create_task.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl;

  TaskRepository({this.baseUrl = 'http://localhost:8080/api/tasks'});

  Future<List<Task>> fetchAllTasks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      switch (res.statusCode) {
        case 200:
          // 成功
          break;
        case 204:
          // Todoリストが空の場合
          return [];
        case 403:
          // Forbidden
          throw Exception('[Repository]Forbidden: ${res.body}');
        case 404:
          // Not Found
          throw Exception('[Repository]Not Found: ${res.body}');
        default:
          // その他のエラー
          throw Exception('[Repository]Unknown Error: ${res.statusCode}');
      }
      if (res.statusCode == 200) {
        final List<dynamic> tasksJson = jsonDecode(res.body);
        return tasksJson.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('[Repository]Responseのステータスコード: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('[Repository]fetchAllTasks:trycatchでのエラー: $e');
    }
  }

  Future<void> createTask(CreateTaskDto params) async {
    try {
      final jsonParams = jsonEncode(params.toJson());

      final res = await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'}, body: jsonParams);
      if (res.statusCode != 201) {
        // 201 Createdは成功を示すため、他のステータスコードはエラーとみなす
        throw Exception('[Repository]create時ステータスコード: ${res.statusCode}');
      }

      // タスクの作成に成功した場合、何も返さない(この責務はproviderに)
    } catch (e) {
      throw Exception('[Repository]create:trycatchでのエラー: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      if (res.statusCode != 204) {
        // 204 No Contentは成功を示すため、他のステータスコードはエラーとみなす
        throw Exception('[Repository]delete時ステータスコード: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('[Repository]delete:trycatchでのエラー: $e');
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:http/http.dart' as http;

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

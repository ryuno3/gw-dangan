import 'dart:convert';
// debugPrint用
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:gw_dangan/models/tasks/create_task.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl;
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

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

  Future<List<Task>> fetchMyTasks() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        debugPrint('[Repository] 未認証のためタスク取得をスキップ');
        return []; // 未認証時は静かに空配列を返す
      }

      final res = await http.get(Uri.parse('$baseUrl/user/${currentUser.uid}'));

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
      debugPrint('[Repository] タスク取得エラー: $e');
      return []; // エラー時も空配列を返す
    }
  }

  Future<void> createTask(CreateTaskDto params) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('[Repository]ユーザーが認証されていません');
      }

      final task = {
        'name': params.name,
        'description': params.description,
        'authorId': firebaseUser.uid,
      };

      final jsonParams = jsonEncode(task);

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

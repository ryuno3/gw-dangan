import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:gw_dangan/models/user/create_user.dart';
import 'package:http/http.dart' as http;
import 'package:gw_dangan/models/user/user.dart';

class UserRepository {
  final String baseUrl;
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  UserRepository({this.baseUrl = "http://localhost:8080/api/users"});

  Future<User> saveUser(CreateUserDto user) async {
    try {
      final String? idToken = await _firebaseAuth.currentUser?.getIdToken();
      if (idToken == null) {
        throw Exception("認証トークンを取得できませんでした");
      }

      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user.toJson()),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // 成功
        final Map<String, dynamic> userJson = jsonDecode(res.body);
        return User.fromJson(userJson);
      } else if (res.statusCode == 403) {
        // Forbidden
        throw Exception('[Repository]認証失敗: ${res.body}');
      } else if (res.statusCode == 404) {
        // Not Found
        throw Exception('[Repository]404 Not Found: ${res.body}');
      } else {
        // その他のエラー
        throw Exception('[Repository]Unknown Error: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('[Repository]saveUser:trycatchでのエラー: $e');
    }
  }

  // ユーザーデータを取得
  Future<User?> getUserData() async {
    try {
      // 現在のFirebaseユーザーを取得
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return null; // 認証されていない場合
      }

      final response = await http.get(
        Uri.parse('$baseUrl/${firebaseUser.uid}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        // ユーザーがまだサーバーに存在しない場合
        // Firebaseから基本情報を使ってユーザーを作成
        return User.fromFirebaseUser(firebaseUser);
      } else {
        throw Exception('ユーザーデータの取得に失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('ユーザーデータの取得中にエラーが発生しました: $e');
    }
  }

  Future<User?> updateUserName(String name) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception("ユーザーがログインしていません");
      }

      // Firebase Authのユーザープロフィールを更新
      await currentUser.updateProfile(displayName: name);
      await currentUser.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception("firebase側:ユーザーの更新に失敗しました");
      }

      // java側のAPIにユーザー名を更新するリクエストを送信
      final String? idToken = await currentUser.getIdToken();
      if (idToken == null) {
        throw Exception("認証トークンを取得できませんでした");
      }

      final res = await http.put(
        Uri.parse('$baseUrl/${currentUser.uid}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'name': name}),
      );

      if (res.statusCode == 200) {
        // 成功
        final Map<String, dynamic> userJson = jsonDecode(res.body);
        return User.fromJson(userJson);
      } else if (res.statusCode == 403) {
        // Forbidden
        throw Exception('[Repository]認証失敗: ${res.body}');
      } else if (res.statusCode == 404) {
        // Not Found
        throw Exception('[Repository]404 Not Found: ${res.body}');
      } else {
        // その他のエラー
        throw Exception('[Repository]Unknown Error: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('[Repository]changeUserName:trycatchでのエラー: $e');
    }
  }
}

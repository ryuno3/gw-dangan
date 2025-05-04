import 'package:gw_dangan/models/tasks/task.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String firebaseUid;
  String? name;
  final String email;
  List<Task> tasks;

  User({
    required this.firebaseUid,
    this.name,
    required this.email,
    this.tasks = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firebaseUid: json['firebaseUid'] as String,
      name: json['name'] as String?,
      email: json['email'] as String,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromJson(task))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory User.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      firebaseUid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
    );
  }
}

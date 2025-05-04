import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';

// 認証状態監視プロバイダー
final authTaskSyncProvider = Provider<void>((ref) {
  // 初期化時に一度だけ認証状態の監視を設定
  ref.listen(authStateProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        // ユーザーがログインしている場合のみタスク取得
        debugPrint('[authTaskSyncProvider] ログイン検知: ${user.uid}');
        ref.read(tasksProvider.notifier).fetchAllTasks();
      } else {
        // ログアウト時はタスクリストをクリア
        debugPrint('[authTaskSyncProvider] ログアウト検知');
        ref.read(tasksProvider.notifier).clearTasks();
      }
    });
  });

  return;
});

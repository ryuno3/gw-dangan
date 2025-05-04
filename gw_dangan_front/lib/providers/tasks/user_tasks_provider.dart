// ユーザー別のタスクプロバイダ

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';

final userTaskProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return const AsyncValue.data([]);
      }

      // ユーザーが認証されている場合、ユーザーのタスクを取得
      return ref.watch(tasksProvider);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, _) => AsyncValue.error(e, StackTrace.current),
  );
});

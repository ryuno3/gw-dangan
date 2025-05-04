import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/models/tasks/create_task.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';
import 'package:gw_dangan/repositories/task_repository.dart';

// ユーザータスク管理用のStateNotifierProvider（型を明示的に指定）
final userTaskNotifierProvider =
    StateNotifierProvider<UserTaskNotifier, AsyncValue<List<Task>>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  final notifier = UserTaskNotifier(taskRepository);

  // 認証状態の変化を監視してnotifierのメソッドを直接呼び出す
  ref.listen(authStateProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        // 循環参照なしでメソッドを直接呼び出す
        debugPrint('[userTaskNotifierProvider] ログイン検知: ${user.uid}');
        notifier.fetchAllTasks();
      } else {
        // 循環参照なしでメソッドを直接呼び出す
        debugPrint('[userTaskNotifierProvider] ログアウト検知');
        notifier.clearTasks();
      }
    });
  });

  return notifier;
});

// 以前のプロバイダーとの互換性のために保持（移行期間中）
final userTaskProvider = Provider<AsyncValue<List<Task>>>((ref) {
  return ref.watch(userTaskNotifierProvider);
});

// ユーザータスク管理クラス
class UserTaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;

  UserTaskNotifier(this._repository) : super(const AsyncValue.data([]));

  // タスクの状態をクリアする関数
  void clearTasks() {
    state = const AsyncValue.data([]);
  }

  // タスクを取得する関数
  Future<void> fetchAllTasks() async {
    // 既にロード中の場合は処理をスキップ
    if (state.isLoading) {
      debugPrint('[UserTaskNotifier] 既にロード中のため、fetchAllTasksをスキップします');
      return;
    }

    debugPrint('[UserTaskNotifier] タスク取得開始');
    state = const AsyncValue.loading();

    try {
      final tasks = await _repository.fetchMyTasks();
      if (mounted) {
        // StateNotifierがまだアクティブか確認
        debugPrint('[UserTaskNotifier] タスク取得成功: ${tasks.length}件');
        state = AsyncValue.data(tasks);
      }
    } catch (e) {
      if (mounted) {
        // StateNotifierがまだアクティブか確認
        debugPrint('[UserTaskNotifier] タスク取得エラー: $e');
        // エラー時でも使用可能な状態を維持（空配列）
        state = const AsyncValue.data([]);
      }
    }
  }

  // タスクを追加する関数
  Future<void> createTask(CreateTaskDto params) async {
    try {
      // 既存の状態をバックアップ
      final previousState = state;

      await _repository.createTask(params);

      // 楽観的更新（UIにすぐに反映）
      if (previousState is AsyncData<List<Task>>) {
        final updatedTasks = [...previousState.value, params.toTask()];
        state = AsyncValue.data(updatedTasks);
      }

      // バックエンドから最新状態を取得
      await fetchAllTasks();
    } catch (e) {
      debugPrint('[UserTaskNotifier] タスク作成エラー: $e');
      // エラーを表面化
      throw Exception('タスクの作成に失敗しました: $e');
    }
  }

  // タスクを削除する関数
  Future<void> deleteTask(int id) async {
    try {
      // 既存の状態をバックアップ
      final previousState = state;

      await _repository.deleteTask(id);

      // 楽観的更新（UIにすぐに反映）
      if (previousState is AsyncData<List<Task>>) {
        final updatedTasks =
            previousState.value.where((task) => task.id != id).toList();
        state = AsyncValue.data(updatedTasks);
      }

      // バックエンドから最新状態を取得
      await fetchAllTasks();
    } catch (e) {
      debugPrint('[UserTaskNotifier] タスク削除エラー: $e');
      // エラーを表面化
      throw Exception('タスクの削除に失敗しました: $e');
    }
  }

  // タスクを完了状態に更新する関数
  Future<void> completeTask(Task task) async {
    try {
      // 既存の状態をバックアップ
      final previousState = state;

      // 実際のAPIリクエスト
      // await _repository.updateTask(task.id, {...});

      // 楽観的更新（UIにすぐに反映）
      if (previousState is AsyncData<List<Task>>) {
        final updatedTasks = previousState.value.map((t) {
          if (t.id == task.id) {
            return task.copyWith(isCompleted: true);
          }
          return t;
        }).toList();
        state = AsyncValue.data(updatedTasks);
      }

      // APIが実装されたら有効化
      // await fetchAllTasks();
    } catch (e) {
      debugPrint('[UserTaskNotifier] タスク更新エラー: $e');
      // エラーを表面化
      throw Exception('タスクの更新に失敗しました: $e');
    }
  }
}

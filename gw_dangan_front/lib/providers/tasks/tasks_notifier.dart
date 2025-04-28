import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:gw_dangan/repositories/task_repository.dart';

// TaskRepositoryのプロバイダー
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// タスク一覧の状態管理のプロバイダー
final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(taskRepository);
});

// タスク一覧の状態管理クラス
class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;

  TasksNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchAllTasks();
  }
  // タスクを取得する関数
  Future<void> fetchAllTasks() async {
    state = const AsyncValue.loading();

    try {
      final tasks = await _repository.fetchAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      debugPrint('[Provider]getAllでエラーが発生しました: $e');
    }
  }

  // タスクを削除する関数
  Future<void> deleteTask(int id) async {
    try {
      final previousState = state;

      await _repository.deleteTask(id);
      // タスクを再取得して状態を更新
      if (previousState is AsyncData<List<Task>>) {
        final updatedTasks =
            previousState.value.where((task) => task.id != id).toList();
        state = AsyncValue.data(updatedTasks);
      }

      await fetchAllTasks();
    } catch (e) {
      debugPrint('[Provider]deleteでエラーが発生しました: $e');
      // エラーが発生した場合は、エラー状態を設定
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

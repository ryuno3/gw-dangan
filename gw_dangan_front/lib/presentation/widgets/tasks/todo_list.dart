import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/presentation/widgets/auth/components/sign_out_button.dart';
import 'package:gw_dangan/presentation/widgets/tasks/components/add_task_button.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/empty_list_view.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/error_view.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/todo_list_view.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';
import 'package:gw_dangan/providers/tasks/user_tasks_provider.dart';

class TodoListWidget extends ConsumerWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タスクの非同期状態を取得
    final tasksAsync = ref.watch(userTaskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        actions: [
          const SignOutButton(isIconButton: true),
          const AddTaskButton(),
          // 既存の更新ボタン
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'タスクを更新',
            onPressed: () => ref.read(tasksProvider.notifier).fetchAllTasks(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(tasksProvider.notifier).fetchAllTasks(),
        child: tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ErrorView(
            error: error,
          ),
          data: (tasks) => tasks.isEmpty
              ? const EmptyListView(message: 'タスクがありません。')
              : TodoListView(tasks: tasks),
        ),
      ),
    );
  }
}

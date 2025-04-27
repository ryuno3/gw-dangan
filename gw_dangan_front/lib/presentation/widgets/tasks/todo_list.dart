import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/empty_list_view.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/error_view.dart';
import 'package:gw_dangan/presentation/widgets/tasks/view/todo_list_view.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';

class TodoListWedget extends ConsumerWidget {
  const TodoListWedget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タスクの非同期状態を取得
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
              onRetry: () => ref.read(tasksProvider.notifier).fetchAllTasks(),
            ),
            data: (tasks) => tasks.isEmpty
                ? const EmptyListView(message: 'タスクがありません。')
                : TodoListView(tasks: tasks),
          )),
    );
  }
}

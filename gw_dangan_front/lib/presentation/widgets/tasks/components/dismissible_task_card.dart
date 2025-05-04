import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:gw_dangan/presentation/widgets/tasks/components/task_card.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';
import 'package:gw_dangan/providers/tasks/user_tasks_provider.dart';

class DismissibleTaskCard extends ConsumerWidget {
  final Task task;
  final VoidCallback? onDismissed;

  const DismissibleTaskCard({
    super.key,
    required this.task,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key('task-${task.id}'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Column(children: [
                  Text(task.name),
                  const SizedBox(height: 10),
                  const Text('タスクを削除しますか？'),
                ]),
                content: const Text('この操作は元に戻せません'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('削除'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) {
        ref.read(userTaskNotifierProvider.notifier).deleteTask(task.id);

        if (onDismissed != null) {
          onDismissed!();
        }
      },
      child: TaskCard(task: task),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gw_dangan/presentation/widgets/tasks/components/create_task_dialog.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  Future<void> _showCreateTaskDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => const CreateTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: '新しいタスクを追加',
      onPressed: () => _showCreateTaskDialog(context),
    );
  }
}

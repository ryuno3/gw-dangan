import 'package:flutter/material.dart';
import 'package:gw_dangan/models/tasks/task.dart';
import 'package:gw_dangan/presentation/widgets/tasks/components/dismissible_task_card.dart';

class TodoListView extends StatelessWidget {
  final List<Task> tasks;

  const TodoListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return DismissibleTaskCard(task: task);
      },
    );
  }
}

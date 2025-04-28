import 'package:flutter/material.dart';

class EmptyListView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRefresh;
  final String refreshButtonText;

  const EmptyListView({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.onRefresh,
    this.refreshButtonText = 'タスクを読み込む',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(refreshButtonText),
            ),
          ],
        ],
      ),
    );
  }
}

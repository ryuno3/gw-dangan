import 'package:flutter/material.dart';

// 優先度情報の型定義
class _PriorityInfo {
  final Color color;
  final String label;

  _PriorityInfo({required this.color, required this.label});
}

class PriorityBadge extends StatelessWidget {
  final String priority;
  const PriorityBadge({super.key, required this.priority});

  // 優先度に応じた情報を取得する関数
  _PriorityInfo _getPriorityInfo(String priority) {
    switch (priority.toUpperCase()) {
      case 'LOW':
        return _PriorityInfo(color: Colors.green, label: '低');
      case 'MEDIUM':
        return _PriorityInfo(color: Colors.blue, label: '中');
      case 'HIGH':
        return _PriorityInfo(color: Colors.orange, label: '高');
      case 'URGENT':
        return _PriorityInfo(color: Colors.red, label: '緊急');
      default:
        return _PriorityInfo(color: Colors.grey, label: '未設定');
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityInfo = _getPriorityInfo(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: priorityInfo.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: priorityInfo.color)),
      child: Text(
        priorityInfo.label,
        style: TextStyle(
          color: priorityInfo.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

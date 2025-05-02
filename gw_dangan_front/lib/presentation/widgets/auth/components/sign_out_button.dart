import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';

class SignOutButton extends ConsumerWidget {
  final bool isIconButton;

  const SignOutButton({
    super.key,
    this.isIconButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isIconButton
        ? _buildIconButton(context, ref)
        : _buildTextButton(context, ref);
  }

  Widget _buildIconButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'ログアウト',
      onPressed: () => _handleLogout(context, ref),
    );
  }

  Widget _buildTextButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => _handleLogout(context, ref),
      icon: const Icon(Icons.logout),
      label: const Text('ログアウト'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signOut();

      // スナックバーでユーザーに通知
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログアウトしました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ログアウトに失敗しました: $e')),
        );
      }
    }
  }
}

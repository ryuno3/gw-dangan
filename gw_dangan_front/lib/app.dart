import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/presentation/screens/auth/sign_in_screen.dart';
import 'package:gw_dangan/presentation/widgets/tasks/todo_list.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';
import 'package:gw_dangan/providers/tasks/tasks_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 認証とタスク同期プロバイダーの初期化
    ref.watch(authTaskSyncProvider);

    // アプリ起動時に強制的にタスク一覧をリフレッシュ（緊急対応）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tasksProvider.notifier).clearTasks();
      ref.read(tasksProvider.notifier).fetchAllTasks();
    });

    // 認証状態
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'GW Dangan App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 197, 116, 58),
        ),
        useMaterial3: true,
      ),
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const TodoListWidget();
          }
          return const SignInScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const SignInScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/presentation/screens/auth/sign_up_screen.dart';
import 'package:gw_dangan/presentation/widgets/auth/view/auth_form.dart';
import 'package:gw_dangan/presentation/widgets/auth/view/auth_header.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';
import 'package:gw_dangan/providers/tasks/tasks_notifier.dart';


class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'サインイン',
                subtitle: 'アカウント情報を入力してサインインしてください',
              ),
              const SizedBox(height: 32),
              AuthForm(
                formType: AuthFormType.signIn,
                onSubmit: (email, password) async {
                  try {
                    await ref.read(signInProvider(
                      SignInParams(email: email, password: password),
                    ).future);
                    
                    ref.read(tasksProvider.notifier).clearTasks();
                    ref.read(tasksProvider.notifier).fetchAllTasks();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('サインインしました')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                onGoogleSignIn: () async {
                  try {
                    await ref.read(googleSignInProvider.future);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Googleでサインインしました')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
              // 新規アカウント作成へのリンク
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'アカウントをお持ちでないですか？',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text('新規登録'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

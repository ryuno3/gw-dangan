import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/presentation/screens/auth/sign_in_screen.dart';
import 'package:gw_dangan/presentation/widgets/auth/view/auth_form.dart';
import 'package:gw_dangan/presentation/widgets/auth/view/auth_header.dart';
import 'package:gw_dangan/providers/auth/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

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
                title: 'アカウント作成',
                subtitle: '新しいアカウントを作成して始めましょう',
              ),
              const SizedBox(height: 32),
              AuthForm(
                formType: AuthFormType.signUp,
                onSubmit: (email, password) async {
                  try {
                    await ref.read(signUpProvider(
                      SignUpParams(email: email, password: password),
                    ).future);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('アカウントを作成しました')),
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
              // アカウントをお持ちの方向けのリンク
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'すでにアカウントをお持ちですか？',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: const Text('サインイン'),
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

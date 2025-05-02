import 'package:flutter/material.dart';
import 'package:gw_dangan/presentation/widgets/auth/components/auth_button.dart';
import 'package:gw_dangan/presentation/widgets/auth/components/auth_divider.dart';
import 'package:gw_dangan/presentation/widgets/auth/components/auth_text_field.dart';
import 'package:gw_dangan/presentation/widgets/auth/components/google_sign_in_button.dart';

// 認証フォームの種類を定義
enum AuthFormType { signIn, signUp }

class AuthForm extends StatefulWidget {
  final AuthFormType formType;
  final Function(String email, String password) onSubmit;
  final VoidCallback onGoogleSignIn;

  const AuthForm({
    super.key,
    required this.formType,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // 認証処理
      widget
          .onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
      )
          .whenComplete(() {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = widget.formType == AuthFormType.signIn;
    final buttonText = isSignIn ? 'サインイン' : '登録';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // メールアドレス入力フィールド
          AuthTextField(
            controller: _emailController,
            labelText: 'メールアドレス',
            hintText: 'example@example.com',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'メールアドレスを入力してください';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return '有効なメールアドレスを入力してください';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // パスワード入力フィールド
          AuthTextField(
            controller: _passwordController,
            labelText: 'パスワード',
            hintText: '********',
            prefixIcon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'パスワードを入力してください';
              }
              if (value.length < 6) {
                return 'パスワードは6文字以上にしてください';
              }
              return null;
            },
          ),

          // サインアップの場合はパスワード確認フィールドを表示
          if (!isSignIn) ...[
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmPasswordController,
              labelText: 'パスワード（確認）',
              hintText: '********',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'パスワードを再入力してください';
                }
                if (value != _passwordController.text) {
                  return 'パスワードが一致しません';
                }
                return null;
              },
            ),
          ],

          const SizedBox(height: 24),

          // サインインボタン
          AuthButton(
            text: buttonText,
            isLoading: _isLoading,
            onPressed: _submitForm,
          ),
          const SizedBox(height: 16),

          // 区切り線
          const AuthDivider(text: 'または'),
          const SizedBox(height: 16),

          // Googleサインインボタン
          GoogleSignInButton(
            onPressed: widget.onGoogleSignIn,
            isDisabled: _isLoading,
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/repositories/auth_repository.dart';

// 認証リポジトリのプロバイダー
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// 認証状態を監視するStreamProvider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

// サインインプロバイダー
final signInProvider =
    FutureProvider.family<UserCredential?, SignInParams>((ref, params) async {
  return ref.read(authRepositoryProvider).signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
});

// サインアッププロバイダー
final signUpProvider =
    FutureProvider.family<UserCredential?, SignUpParams>((ref, params) async {
  return ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
});

// Googleサインインプロバイダー
final googleSignInProvider = FutureProvider<UserCredential?>((ref) async {
  return ref.read(authRepositoryProvider).signInWithGoogle();
});

// サインアウトプロバイダー
final signOutProvider = FutureProvider<void>((ref) async {
  return ref.read(authRepositoryProvider).signOut();
});

// サインインパラメータクラス
class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

// サインアップパラメータクラス
class SignUpParams {
  final String email;
  final String password;

  SignUpParams({required this.email, required this.password});
}

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gw_dangan/models/user/user.dart';
import 'package:gw_dangan/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    return UserRepository();
  },
);

final firebaseAuthProvider = StreamProvider<firebase_auth.User?>((ref) {
  return firebase_auth.FirebaseAuth.instance.authStateChanges();
});

final userProvider = FutureProvider<User?>((ref) async {
  final firebaseUser = await ref.watch(firebaseAuthProvider.future);

  if (firebaseUser == null) {
    return null; // ユーザーがログインしていない場合
  }

  try {
    return await ref.read(userRepositoryProvider).getUserData();
  } catch (e) {
    return User.fromFirebaseUser(firebaseUser);
  }
});

final updateUserNameProvider =
    FutureProvider.family<void, String>((ref, name) async {
  final user = await ref.watch(userProvider.future);
  if (user == null) {
    throw Exception('[Provider]UserDataが見つかりません');
  }
  await ref.read(userRepositoryProvider).updateUserName(name);
});

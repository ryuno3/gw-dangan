import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 認証状態の変化を監視するStream
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // メールとパスワードでサインイン
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // メールとパスワードでユーザー登録
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Googleでサインイン
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Googleサインインフローを開始
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // ユーザーがサインインをキャンセルした場合
      }

      // 認証情報を取得
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // FirebaseAuthに認証情報を渡す
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase認証を実行
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // サインアウト
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // 認証エラーを日本語に変換
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('ユーザーが見つかりません');
      case 'wrong-password':
        return Exception('パスワードが間違っています');
      case 'invalid-email':
        return Exception('メールアドレスの形式が正しくありません');
      case 'user-disabled':
        return Exception('このユーザーは無効になっています');
      case 'too-many-requests':
        return Exception('リクエストが多すぎます。しばらく待ってから再試行してください');
      case 'operation-not-allowed':
        return Exception('この操作は許可されていません');
      case 'email-already-in-use':
        return Exception('このメールアドレスは既に使用されています');
      case 'weak-password':
        return Exception('パスワードが弱すぎます');
      default:
        return Exception('認証エラーが発生しました: ${e.message}');
    }
  }
}

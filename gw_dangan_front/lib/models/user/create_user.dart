import 'package:gw_dangan/models/user/user.dart';

class CreateUserDto {
  final String firebaseUid;
  final String name;
  final String email;

  CreateUserDto({
    required this.firebaseUid,
    this.name = '',
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
    };
  }

  // Userオブジェクトに変換するメソッド
  User toUser() {
    return User(
      firebaseUid: firebaseUid,
      name: name,
      email: email, // ここは適切なフィールドに変更してください
    );
  }
}

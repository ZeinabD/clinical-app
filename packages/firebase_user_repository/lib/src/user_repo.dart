import 'package:clinical/models/my_user.dart';

abstract class UserRepo {
  Future<void> signin(String email, String password);

  Future<MyUser> signup(MyUser user, String password);

  Future<void> signout();

  Stream<MyUser?> get user;

  Future<void> updateUserInfo(MyUser updatedUser);

  Future<MyUser?> getMyUser(String uid);
}
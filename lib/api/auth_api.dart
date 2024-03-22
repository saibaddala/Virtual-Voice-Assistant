import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';

class AuthApi {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  Future<Either<User, String>> signUp(
      {required String email, required String password}) async {
    try {
      final userId = ID.unique();
      final User user = await _account.create(
        userId: userId,
        email: email,
        password: password,
      );
      return left(user);
    } on AppwriteException catch (errorMsg) {
      return right(errorMsg.toString());
    } catch (errorMsg) {
      return right(errorMsg.toString());
    }
  }

  Future<Either<Session, String>> signIn(
      {required String email, required String password}) async {
    try {
      final Session session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return left(session);
    } on AppwriteException catch (errorMsg) {
      return right(errorMsg.toString());
    } catch (errorMsg) {
      return right(errorMsg.toString());
    }
  }

  Future<Either<String, String>> signOut() async {
    try {
      final String session = await _account.deleteSession(sessionId: 'current');
      return left(session);
    } on AppwriteException catch (errorMsg) {
      return right(errorMsg.toString());
    } catch (errorMsg) {
      return right(errorMsg.toString());
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final user = await _account.get();
      return user;
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }
}

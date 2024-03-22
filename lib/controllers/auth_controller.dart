import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:titer/api/auth_api.dart';
import 'package:titer/ui/constants/routes.dart';
import 'package:titer/ui/custom_widgets/snackbar.dart';

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  Future<String> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String uid = "";
    state = true;
    final Either<User, String> result =
        await _authApi.signUp(email: email, password: password);
    result.fold((l) {
      showSnackBar(context, "Wooohooo..Account created,it's time to hop in");
      state = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Routes.signInScreenRoute()),
          (Route<dynamic> route) => false);
      uid = l.$id;
    }, (r) {
      state = false;
      showSnackBar(context, r);
    });
    return uid;
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final Either<Session, String> result =
        await _authApi.signIn(email: email, password: password);
    result.fold((l) {
      state = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Routes.homeScreenRoute(),
          ),
          (route) => false);
    }, (r) {
      state = false;
      showSnackBar(context, r);
    });
  }

  void signOut({required BuildContext context}) async {
    final Either<String, String> result = await _authApi.signOut();
    result.fold((l) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Routes.signInScreenRoute(),
          ),
          (route) => false);
    }, (r) {
      showSnackBar(context, r);
    });
  }

  Future<User?> getCurrentUser() async {
    final user = await _authApi.getCurrentUser();
    return user;
  }
}

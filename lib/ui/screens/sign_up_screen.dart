import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/ui/constants/routes.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/constants/ui_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/controllers/auth_controller.dart';
import 'package:titer/controllers/user_controller.dart';
import 'package:titer/ui/custom_widgets/text_field.dart';
import 'package:titer/ui/custom_widgets/round_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final AppBar appBar = UIConstants.appBar();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUpAndSaveUserDetails() async {
    String uid = await signUp();
    saveUserDetails(uid);
  }

  Future<String> signUp() async {
    final AuthController authController =
        ref.read(authControllerProvider.notifier);
    final String uid = await authController.signUp(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
    return uid;
  }

  void saveUserDetails(String uid) {
    final UserController userController = ref.read(userControllerProvider);
    UserModel userModel = UserModel(
      email: emailController.text,
      name: "Sai",
      followers: const [],
      following: const [],
      profilePic: "",
      bannerPic: "",
      uid: uid,
      bio: "",
      isTwitterBlue: false,
    );
    userController.saveUserDetails(userModel: userModel);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const LoadingIndicator()
          : Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topRight,
                    child: RoundedButton(
                      onTap: signUpAndSaveUserDetails,
                      text: 'SignUp',
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text:
                        TextSpan(text: 'Already have an account? ', children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Routes.signInScreenRoute(),
                              ),
                            );
                          },
                        text: 'SignIn',
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
                  ),
                ]),
              ),
            ),
    );
  }
}

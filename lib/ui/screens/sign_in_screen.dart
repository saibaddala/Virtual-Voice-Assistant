import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/controllers/auth_controller.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/constants/routes.dart';
import 'package:titer/ui/constants/ui_constants.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/round_button.dart';
import 'package:titer/ui/custom_widgets/text_field.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final AppBar appBar = UIConstants.appBar();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signIn() {
    final AuthController authController =
        ref.read(authControllerProvider.notifier);
    authController.signIn(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
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
                      onTap: signIn,
                      text: 'SignIn',
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(text: "Don't have an account? ", children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Routes.signUpScreenRoute(),
                              ),
                            );
                          },
                        text: 'SignUp',
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

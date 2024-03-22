import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/ui/constants/ui_constants.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/screens/home_screen.dart';
import 'package:titer/ui/screens/sign_up_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: Titer(),
    ),
  );
}

class Titer extends ConsumerWidget {
  const Titer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Titer',
      debugShowCheckedModeBanner: false,
      home: ref.watch(currentUserProvider).when(data: (user) {
        if (user != null) {
          return const HomeScreen();
        } else {
          return const SignUpScreen();
        }
      }, error: ((error, stackTrace) {
        return const Center(
          child: Text("Something is Wrong...."),
        );
      }), loading: () {
        return const LoadingPage();
      }),
      theme: UIConstants.theme,
    );
  }
}

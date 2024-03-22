import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/custom_widgets/user_profile.dart';

class UserProfileScreen extends ConsumerWidget {
  final UserModel user;
  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUpdatedDetailsOfUserProvider).when(data: (data) {
        UserModel updatedUser = user;
        if (data.events.contains(
            'databases.*.collections.${AppwriteConstants.usersCollectionId}.documents.*.update')) {
          updatedUser = UserModel.fromMap(data.payload);
        }
        return UserProfile(user: updatedUser);
      }, error: (error, stackTrace) {
        return const Center(
          child: Text("Some Error Occurred"),
        );
      }, loading: () {
        return UserProfile(user: user);
      }),
    );
  }
}

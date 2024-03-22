import 'package:flutter/material.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/constants/routes.dart';

class SearchTile extends StatelessWidget {
  final UserModel user;
  const SearchTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Routes.userProfileScreenRoute(user),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          user.profilePic,
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

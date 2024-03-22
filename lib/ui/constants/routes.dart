import 'package:titer/models/user_model.dart';
import 'package:titer/ui/screens/create_tweet_screen.dart';
import 'package:titer/ui/screens/edit_profile_screen.dart';
import 'package:titer/ui/screens/hashtag_screen.dart';
import 'package:titer/ui/screens/home_screen.dart';
import 'package:titer/ui/screens/notification_screens.dart';
import 'package:titer/ui/screens/sign_in_screen.dart';
import 'package:titer/ui/screens/sign_up_screen.dart';
import 'package:titer/ui/screens/user_profile_screen.dart';

class Routes {
  static signInScreenRoute() => const SignInScreen();
  static signUpScreenRoute() => const SignUpScreen();
  static homeScreenRoute() => const HomeScreen();
  static createTweetScreenRoute() => const CreateTweetScreen();
  static userProfileScreenRoute(UserModel user) =>
      UserProfileScreen(user: user);
  static editProfileScreenRoute() => const EditProfileScreen();
  static notificationsScreenRoute() => const NotificationsScreen();
  static hashtagScreenRoute(String hashtag) => HashtagScreen(hashtag: hashtag);
}

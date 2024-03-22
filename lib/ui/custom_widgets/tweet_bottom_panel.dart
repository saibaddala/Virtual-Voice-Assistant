import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/controllers/notification_controller.dart';
import 'package:titer/controllers/tweet_controller.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/constants/assets_constants.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/custom_widgets/tweet_bottom_icon.dart';
import 'package:like_button/like_button.dart';
import 'package:titer/ui/screens/tweet_reply_screen.dart';

class TweetBottomPanel extends ConsumerWidget {
  final TweetModel tweet;
  const TweetBottomPanel({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TweetController tweetController =
        ref.read(tweetControllerProvider.notifier);
    final NotificationController notificationController =
        ref.read(notificationsControllerProvider.notifier);
    final UserModel? currentUser = ref.watch(currentUserDetailsProvider).value;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetBottomIcon(
            iconPath: AssetsConstants.commentIcon,
            val: '${tweet.comments.length}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TweetReplyScreen(
                    tweet: tweet,
                    user: currentUser!,
                  );
                }),
              );
            },
          ),
          TweetBottomIcon(
            iconPath: AssetsConstants.retweetIcon,
            val: '${tweet.retweetedCount}',
            onTap: () async {
              bool isdone = await tweetController.reTweet(tweet, currentUser!);
              if (isdone) {
                // ignore: use_build_context_synchronously
                notificationController.createTweetNotification(
                  notificationType: 'retweet',
                  notificationText: '${currentUser.name} retweeted your tweet',
                  interactedToTweetOfuserId: tweet.uid,
                  interactedOntweetId: tweet.tweetId,
                  context: context,
                );
              }
            },
          ),
          LikeButton(
            size: 17,
            onTap: (isLiked) async {
              bool isdone = await tweetController.likeTweet(tweet, currentUser);
              if (isdone) {
                // ignore: use_build_context_synchronously
                notificationController.createTweetNotification(
                  notificationType: 'like',
                  notificationText: '${currentUser.name} liked your tweet',
                  interactedToTweetOfuserId: tweet.uid,
                  interactedOntweetId: tweet.tweetId,
                  context: context,
                );
              }
              return !isLiked;
            },
            isLiked: tweet.likes.contains(currentUser!.uid),
            likeBuilder: (isLiked) {
              return isLiked
                  ? SvgPicture.asset(
                      AssetsConstants.likeFilledIcon,
                      colorFilter: const ColorFilter.mode(
                          Pallete.redColor, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      AssetsConstants.likeOutlinedIcon,
                      colorFilter: const ColorFilter.mode(
                          Pallete.greyColor, BlendMode.srcIn),
                    );
            },
            likeCount: tweet.likes.length,
            countBuilder: (likeCount, isLiked, text) {
              return Text(
                text,
                style: TextStyle(
                  color: isLiked ? Pallete.redColor : Pallete.greyColor,
                ),
              );
            },
          ),
          TweetBottomIcon(
            iconPath: AssetsConstants.viewsIcon,
            val: '2.4k',
            onTap: () {},
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.share_outlined,
              size: 17,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

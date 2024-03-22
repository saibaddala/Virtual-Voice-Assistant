import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/constants/assets_constants.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/constants/routes.dart';
import 'package:titer/ui/custom_widgets/follow_count.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/tweet_card.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(currentUserProvider).value!;
    final currUserDetails = ref.watch(currentUserDetailsProvider).value!;
    final usercontroller = ref.read(userControllerProvider);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 150,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: user.bannerPic.isNotEmpty
                        ? Image.network(
                            user.bannerPic,
                            fit: BoxFit.fitWidth,
                          )
                        : Container(
                            color: Pallete.blueColor,
                          ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.profilePic,
                      ),
                      radius: 35,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(5),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (currUser.$id == user.uid) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Routes.editProfileScreenRoute(),
                            ),
                          );
                        } else {
                          bool isdone =
                              await usercontroller.followOrunfollowUser(
                            currUserDetails,
                            user,
                            context,
                          );
                          if (isdone) {
                            // ignore: use_build_context_synchronously
                            ref
                                .read(notificationsControllerProvider.notifier)
                                .createFollowNotification(
                                  notificationType: 'follow',
                                  notificationText:
                                      '${currUser.name} followed you',
                                  followedBy: currUser.$id,
                                  followed: user.uid,
                                  context: context,
                                );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ),
                      child: Text(
                        currUser.$id == user.uid
                            ? 'Edit Profile'
                            : currUserDetails.following.contains(user.uid)
                                ? 'Unfollow'
                                : 'follow',
                        style: const TextStyle(
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.isTwitterBlue)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: SvgPicture.asset(
                              AssetsConstants.verifiedIcon,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '@${user.name}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Pallete.greyColor,
                      ),
                    ),
                    Text(
                      user.bio,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      children: [
                        FollowCount(
                          count: user.following.length,
                          text: 'Following',
                        ),
                        const SizedBox(width: 15),
                        FollowCount(
                          count: user.followers.length,
                          text: 'Followers',
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Divider(color: Colors.white70),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ref.watch(getAllTweetsByUserProvider(user)).when(
            data: (tweets) {
              return ref.watch(getLatestTweetsProvider).when(data: (newTweet) {
                final latestTweet = TweetModel.fromMap(newTweet.payload);
                if (tweets.indexWhere(
                        (element) => element.tweetId == latestTweet.tweetId) ==
                    -1) {
                  if (newTweet.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create')) {
                    tweets.insert(0, TweetModel.fromMap(newTweet.payload));
                  } else if (newTweet.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update')) {
                    final String newTweetId = newTweet.payload['\$id'];
                    final int updatedCount = newTweet.payload['retweetedCount'];
                    int thatTweetIndex = tweets
                        .indexWhere((tweet) => tweet.tweetId == newTweetId);
                    final updatedTweet = tweets[thatTweetIndex]
                        .copyWith(retweetedCount: updatedCount);
                    tweets[thatTweetIndex] = updatedTweet;
                  }
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel? user;
                        ref
                            .watch(userDetailsProvider(tweets[index].uid))
                            .whenData((value) {
                          user = value;
                        });
                        return TweetCard(
                          tweet: tweets[index],
                          user: user!,
                        );
                      }),
                );
              }, error: (error, stackTrace) {
                return const Center(
                  child: Text("Some Error Occurred"),
                );
              }, loading: () {
                return Expanded(
                  child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel? user;
                        ref
                            .watch(userDetailsProvider(tweets[index].uid))
                            .whenData((value) {
                          user = value;
                        });
                        return TweetCard(
                          tweet: tweets[index],
                          user: user!,
                        );
                      }),
                );
              });
            },
            error: (error, stackTrace) {
              return const Center(
                child: Text("Some Error Occurred"),
              );
            },
            loading: () => const LoadingIndicator()),
      ),
    );
  }
}

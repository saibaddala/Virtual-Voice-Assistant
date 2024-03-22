import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/constants/ui_constants.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/tweet_card.dart';

class TweetReplyScreen extends ConsumerWidget {
  final TweetModel tweet;
  final UserModel user;
  const TweetReplyScreen({
    super.key,
    required this.tweet,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: Column(
        children: [
          TweetCard(tweet: tweet, user: user),
          ref.watch(getTweetRepliesProvider(tweet)).when(
              data: (tweets) {
                return ref.watch(getLatestTweetsProvider).when(
                    data: (newTweet) {
                  final latestTweet = TweetModel.fromMap(newTweet.payload);
                  if (latestTweet.repliedTo == tweet.tweetId &&
                      tweets.indexWhere((element) =>
                              element.tweetId == latestTweet.tweetId) ==
                          -1) {
                    if (newTweet.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create')) {
                      tweets.insert(0, TweetModel.fromMap(newTweet.payload));
                    } else if (newTweet.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update')) {
                      final String newTweetId = newTweet.payload['\$id'];
                      final int updatedCount =
                          newTweet.payload['retweetedCount'];
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
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) async {
          bool isdone =
              await ref.read(tweetControllerProvider.notifier).shareTweet(
                    uid: user.uid,
                    images: [],
                    text: value,
                    context: context,
                    repliedToTweetId: tweet.tweetId,
                  );
          if (isdone) {
            // ignore: use_build_context_synchronously
            ref.read(notificationsControllerProvider.notifier).createTweetNotification(
                  notificationType: 'reply',
                  notificationText: '${user.name} replied to your tweet',
                  interactedToTweetOfuserId: tweet.uid,
                  interactedOntweetId: tweet.tweetId,
                  context: context,
                );
          }
        },
        decoration: const InputDecoration(
          hintText: 'Write a Reply',
          hintStyle: TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

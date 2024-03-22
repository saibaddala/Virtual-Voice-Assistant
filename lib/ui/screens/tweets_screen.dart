import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/tweet_card.dart';

class TweetsScreen extends ConsumerStatefulWidget {
  const TweetsScreen({super.key});

  @override
  ConsumerState<TweetsScreen> createState() => _TweetsScreenState();
}

class _TweetsScreenState extends ConsumerState<TweetsScreen> {
  List<TweetModel> tweets = [];

  @override
  Widget build(BuildContext context) {
    return ref.watch(getTweetsProvider).when(
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
                int thatTweetIndex =
                    tweets.indexWhere((tweet) => tweet.tweetId == newTweetId);
                final updatedTweet = tweets[thatTweetIndex]
                    .copyWith(retweetedCount: updatedCount);
                tweets[thatTweetIndex] = updatedTweet;
              }
            }

            return ListView.builder(
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
                });
          }, error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return ListView.builder(
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
                });
          });
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text("Some Error Occurred"),
          );
        },
        loading: () => const LoadingPage());
  }
}

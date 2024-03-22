import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/tweet_card.dart';

class HashtagScreen extends ConsumerWidget {
  final String hashtag;
  const HashtagScreen({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
          data: (tweets) {
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
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
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const LoadingIndicator()),
    );
  }
}

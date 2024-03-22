import 'dart:io';
import 'package:flutter/material.dart';
import 'package:titer/api/tweet_api.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/custom_widgets/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as appwritemodels;
import 'package:titer/controllers/storage_controller.dart';

class TweetController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageController _storageController;

  TweetController({
    required TweetApi tweetApi,
    required StorageController storageController,
  })  : _tweetApi = tweetApi,
        _storageController = storageController,
        super(false);

  Future<bool> shareTweet({
    required String uid,
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedToTweetId,
  }) async {
    if (text.isEmpty && images.isEmpty) {
      showSnackBar(context, "Please add some text");
      return false;
    }
    if (text.isEmpty) {
      text = '';
    }
    if (images.isNotEmpty) {
      return await _shareImageTweet(
        uid: uid,
        images: images,
        text: text,
        context: context,
        repliedToTweetId: repliedToTweetId,
      );
    } else {
      return await _shareTextTweet(
        uid: uid,
        text: text,
        context: context,
        repliedToTweetId: repliedToTweetId,
      );
    }
  }

  Future<bool> _shareImageTweet({
    required String uid,
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedToTweetId,
  }) async {
    state = true;
    final List<String> hashtags = _getHashtagsFromText(text);
    final String link = _getLinksFromText(text);
    final List<String> imageLinks =
        await _storageController.storeImages(images);
    TweetModel tweetModel = TweetModel(
      uid: uid,
      tweetId: '',
      tweetType: 'image',
      text: text,
      tweetedAt: DateTime.now(),
      link: link,
      hashtags: hashtags,
      imageLinks: imageLinks,
      likes: const [],
      comments: const [],
      retweetedCount: 0,
      retweetedBy: '',
      repliedTo: repliedToTweetId,
    );
    final res = await _tweetApi.shareTweet(tweetModel);
    state = false;
    bool isdone = false;
    res.fold((l) {
      isdone = true;
    }, (r) {
      showSnackBar(context, r);
    });
    return isdone;
  }

  Future<bool> _shareTextTweet({
    required String uid,
    required String text,
    required BuildContext context,
    required String repliedToTweetId,
  }) async {
    state = true;
    final List<String> hashtags = _getHashtagsFromText(text);
    final String link = _getLinksFromText(text);
    TweetModel tweetModel = TweetModel(
      uid: uid,
      tweetId: '',
      tweetType: 'text',
      text: text,
      tweetedAt: DateTime.now(),
      link: link,
      hashtags: hashtags,
      imageLinks: const [],
      likes: const [],
      comments: const [],
      retweetedCount: 0,
      retweetedBy: '',
      repliedTo: repliedToTweetId,
    );

    final res = await _tweetApi.shareTweet(tweetModel);
    state = false;
    bool isdone = false;
    res.fold((l) {
      isdone = true;
    }, (r) {
      showSnackBar(context, r);
    });
    return isdone;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> words = text.split(' ');
    for (final word in words) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  String _getLinksFromText(String text) {
    String link = '';
    List<String> words = text.split(' ');
    for (final word in words) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  Future<List<TweetModel>> getTweets() async {
    final res = await _tweetApi.getTweets();
    List<TweetModel> tweets = [];
    res.fold((l) {
      final List<appwritemodels.Document> documents = l;
      for (final document in documents) {
        final tweetDocument = document.toMap();
        final tweetDoc = tweetDocument['data'] as Map<String, dynamic>;
        tweets.add(
          TweetModel.fromMap(tweetDoc),
        );
      }
    }, (r) {});
    return tweets;
  }

  Future<bool> likeTweet(TweetModel tweet, UserModel user) async {
    List<String> likes = tweet.likes;

    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetApi.likeTweet(tweet);
    bool isdone = false;
    res.fold((l) {
      isdone = true;
    }, (r) => null);
    return likes.contains(user.uid) ? isdone : false;
  }

  Future<bool> reTweet(TweetModel tweet, UserModel user) async {
    final int count = tweet.retweetedCount;
    final TweetModel countUpdatedTweet = tweet.copyWith(
      retweetedCount: count + 1,
    );
    await _tweetApi.updateRetweetedCount(countUpdatedTweet);

    final TweetModel tweetToBeRetweetByCurrUser = tweet.copyWith(
      uid: user.uid,
      retweetedBy: user.name,
      tweetedAt: DateTime.now(),
      likes: [],
      comments: [],
      retweetedCount: 0,
    );
    final res = await _tweetApi.shareTweet(tweetToBeRetweetByCurrUser);
    bool isdone = false;
    res.fold((l) {
      isdone = true;
    }, (r) {});
    return isdone;
  }

  Future<List<TweetModel>> getTweetReplies(TweetModel tweet) async {
    final res = await _tweetApi.getTweetReplies(tweet);
    List<TweetModel> tweets = [];
    res.fold((l) {
      final List<appwritemodels.Document> documents = l;
      for (final document in documents) {
        final tweetDocument = document.toMap();
        final tweetDoc = tweetDocument['data'] as Map<String, dynamic>;
        tweets.add(
          TweetModel.fromMap(tweetDoc),
        );
      }
    }, (r) {});
    return tweets;
  }

  Future<TweetModel> getTweetByTweetId(String tweetId) async {
    TweetModel? tweet;
    final res = await _tweetApi.getTweetById(tweetId);
    res.fold((l) {
      final tweetDocument = l.toMap();
      final tweetDoc = tweetDocument['data'] as Map<String, dynamic>;
      tweet = TweetModel.fromMap(tweetDoc);
    }, (r) => null);
    return tweet!;
  }

  Future<List<TweetModel>> getAllTweetsByUser(UserModel user) async {
    final res = await _tweetApi.getAllTweetsByUser(user);
    List<TweetModel> tweets = [];
    res.fold((l) {
      final List<appwritemodels.Document> documents = l;
      for (final document in documents) {
        final tweetDocument = document.toMap();
        final tweetDoc = tweetDocument['data'] as Map<String, dynamic>;
        tweets.add(
          TweetModel.fromMap(tweetDoc),
        );
      }
    }, (r) {});
    return tweets;
  }

  Future<List<TweetModel>> getTweetsByHashtag(String hashtag) async {
    final res = await _tweetApi.getTweetsByHashtag(hashtag);
    List<TweetModel> tweets = [];
    res.fold((l) {
      final List<appwritemodels.Document> documents = l;
      for (final document in documents) {
        final tweetDocument = document.toMap();
        final tweetDoc = tweetDocument['data'] as Map<String, dynamic>;
        tweets.add(
          TweetModel.fromMap(tweetDoc),
        );
      }
    }, (r) {});
    return tweets;
  }
}

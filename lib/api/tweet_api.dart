import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';

class TweetApi {
  final Databases _databases;
  final Realtime _realtime;
  TweetApi({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  Future<Either<Document, String>> shareTweet(TweetModel tweetModel) async {
    try {
      final Document document = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweetModel.toMap(),
      );
      return left(document);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Future<Either<List<Document>, String>> getTweets() async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [Query.orderDesc('tweetedAt')],
      );
      return left(documents.documents);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Future<Either<List<Document>, String>> getTweetReplies(
      TweetModel tweet) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [
          Query.equal(
            'repliedTo',
            tweet.tweetId,
          )
        ],
      );
      return left(documents.documents);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollectionId}.documents',
      ],
    ).stream;
  }

  Future<Either<Document, String>> likeTweet(TweetModel tweetModel) async {
    try {
      final Document document = await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: tweetModel.tweetId,
        data: {
          'likes': tweetModel.likes,
        },
      );
      return left(document);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Future<Either<Document, String>> updateRetweetedCount(
      TweetModel tweetModel) async {
    try {
      final Document document = await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: tweetModel.tweetId,
        data: {
          'retweetedCount': tweetModel.retweetedCount,
        },
      );
      return left(document);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Future<Either<Document, String>> getTweetById(String tweetId) async {
    try {
      final Document document = await _databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: tweetId,
      );
      return left(document);
    } catch (e) {
      return right(e.toString());
    }
  }

  Future<Either<List<Document>, String>> getAllTweetsByUser(
      UserModel user) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [
          Query.equal(
            'uid',
            user.uid,
          )
        ],
      );
      return left(documents.documents);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }

  Future<Either<List<Document>, String>> getTweetsByHashtag(
      String hashtag) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [
          Query.search(
            'hashtags',
            hashtag,
          )
        ],
      );
      return left(documents.documents);
    } on AppwriteException catch (errorMsg) {
      return right(
        errorMsg.message.toString(),
      );
    } catch (errorMsg) {
      return right(
        errorMsg.toString(),
      );
    }
  }
}

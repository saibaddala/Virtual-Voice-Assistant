import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/models/notification_model.dart';

class NotificationApi {
  final Databases _databases;
  final Realtime _realtime;
  final Realtime _realtime2;

  NotificationApi({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  Future<Either<Document, String>> createNotification(
      {required NotificationModel notification}) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return left(doc);
    } catch (e) {
      return right(e.toString());
    }
  }

  Future<Either<List<Document>, String>> getAllNotificationsOfUser(
      String uid) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        queries: [
          Query.equal(
            'interactedToTweetOfuserId',
            uid,
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

  Stream<RealtimeMessage> getNotificationsRealtime() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollectionId}.documents',
    ]).stream;
  }
}

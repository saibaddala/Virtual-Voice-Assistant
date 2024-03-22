import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/models/user_model.dart';

class UserApi {
  final Databases _databases;
  final Realtime _realtime;

  UserApi({required Databases databases, required Realtime realtime})
      : _databases = databases,
        _realtime = realtime;

  Future<String> saveUserDetails({required UserModel userModel}) async {
    try {
      await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      return "User Details Saved Succesfully";
    } on AppwriteException catch (errorMsg) {
      return errorMsg.message ?? "Appwrite exception Caught";
    } catch (errorMsg) {
      return errorMsg.toString();
    }
  }

  Future<Document> getUserDetails({required String uid}) async {
    final doc = await _databases.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: uid,
    );
    return doc;
  }

  Future<List<Document>> searchUsersByName(String name) async {
    final docs = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      queries: [
        Query.search('name', name),
      ],
    );
    return docs.documents;
  }

  Future<Either<String, String>> updateUserProfile(
      {required UserModel userModel}) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
    
      return left("User Details updated Succesfully");
    } on AppwriteException catch (errorMsg) {
      return right(errorMsg.message ?? "Appwrite exception Caught");
    } catch (errorMsg) {
      return right(errorMsg.toString());
    }
  }

  Stream<RealtimeMessage> getUpdatedDetailsOfUser() {
    return _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollectionId}.documents',
      ],
    ).stream;
  }

  Future<Either<String, String>> updateFollowingAndFollowers(
      {required UserModel currUser, required UserModel user}) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: currUser.uid,
        data: {
          'following': currUser.following,
        },
      );
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );

      return left("Done");
    } on AppwriteException catch (errorMsg) {
      return right(errorMsg.message ?? "Appwrite exception Caught");
    } catch (errorMsg) {
      return right(errorMsg.toString());
    }
  }
}

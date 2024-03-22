import 'package:appwrite/models.dart';
import 'package:appwrite/appwrite.dart';
import 'package:titer/api/notification_api.dart';
import 'package:titer/api/user_api.dart';
import 'package:titer/api/auth_api.dart';
import 'package:titer/api/tweet_api.dart';
import 'package:titer/api/storage_api.dart';
import 'package:titer/controllers/notification_controller.dart';
import 'package:titer/models/notification_model.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/controllers/user_controller.dart';
import 'package:titer/controllers/tweet_controller.dart';
import 'package:titer/controllers/storage_controller.dart';

final Provider<Client> appwriteClientProvider = Provider((_) {
  final Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId);
});

final Provider<Account> appwriteAccountProvider = Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final Provider<Databases> appwriteDatabaseProvider = Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final Provider<Storage> appwriteStorageProvider = Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final Provider<Realtime> appwriteUsersRealtimeProvider = Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final Provider<Realtime> appwriteTweetsRealtimeProvider = Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final Provider<Realtime> appwriteNotificationsRealtimeProvider =
    Provider((ref) {
  final Client client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final Provider<AuthApi> authApiProvider = Provider((ref) {
  final Account account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

final FutureProvider<User?> currentUserProvider = FutureProvider<User?>((ref) {
  final AuthController authController =
      ref.watch(authControllerProvider.notifier);
  return authController.getCurrentUser();
});

final Provider<UserApi> userApiProvider = Provider((ref) {
  final Databases databases = ref.watch(appwriteDatabaseProvider);
  final Realtime realtime = ref.watch(appwriteUsersRealtimeProvider);
  return UserApi(databases: databases, realtime: realtime);
});

final Provider<TweetApi> tweetApiProvider = Provider((ref) {
  final Databases databases = ref.watch(appwriteDatabaseProvider);
  final Realtime realtime = ref.watch(appwriteTweetsRealtimeProvider);
  return TweetApi(databases: databases, realtime: realtime);
});

final Provider<StorageApi> storageApiProvider = Provider((ref) {
  final Storage storage = ref.watch(appwriteStorageProvider);
  return StorageApi(storage: storage);
});

final Provider<NotificationApi> notificationApiProvider = Provider((ref) {
  final Databases databases = ref.watch(appwriteDatabaseProvider);
  final Realtime realtime = ref.watch(appwriteUsersRealtimeProvider);
  return NotificationApi(databases: databases, realtime: realtime);
});

final StateNotifierProvider<AuthController, bool> authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final AuthApi authApi = ref.watch(authApiProvider);
  return AuthController(authApi: authApi);
});

final Provider<UserController> userControllerProvider = Provider((ref) {
  final UserApi userApi = ref.watch(userApiProvider);
  return UserController(userApi: userApi);
});

final FutureProviderFamily<UserModel, String> userDetailsProvider =
    FutureProvider.family((ref, String uid) async {
  final UserController userController = ref.watch(userControllerProvider);
  final userDetails = await userController.getUserDetails(uid: uid);
  return userDetails;
});

final FutureProvider<UserModel?> currentUserDetailsProvider =
    FutureProvider((ref) {
  final String currentUserId = ref.watch(currentUserProvider).value!.$id;
  final currentUserDetails = ref.watch(userDetailsProvider(currentUserId));
  return currentUserDetails.value;
});

final StateNotifierProvider<TweetController, bool> tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  final TweetApi tweetApi = ref.watch(tweetApiProvider);
  final StorageController storageController =
      ref.watch(storageControllerProvider);
  return TweetController(
    tweetApi: tweetApi,
    storageController: storageController,
  );
});

final Provider<StorageController> storageControllerProvider = Provider((ref) {
  final StorageApi storageApi = ref.watch(storageApiProvider);
  return StorageController(storageApi: storageApi);
});

final StateNotifierProvider<NotificationController, bool>
    notificationsControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final NotificationApi notificationApi = ref.watch(notificationApiProvider);
  return NotificationController(notificationApi: notificationApi);
});

final FutureProvider<List<TweetModel>> getTweetsProvider =
    FutureProvider((ref) {
  final TweetController tweetController =
      ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final FutureProviderFamily<List<TweetModel>, TweetModel>
    getTweetRepliesProvider =
    FutureProvider.family((ref, TweetModel tweet) async {
  final TweetController tweetController =
      ref.watch(tweetControllerProvider.notifier);
  final tweets = await tweetController.getTweetReplies(tweet);
  return tweets;
});

final FutureProviderFamily<List<NotificationModel>, String>
    getNotificationsOfUserProvider =
    FutureProvider.family((ref, String uid) async {
  final NotificationController notificationController =
      ref.watch(notificationsControllerProvider.notifier);
  final notifications =
      await notificationController.getAllNotificationsOfUser(uid);
  return notifications;
});

final StreamProvider<RealtimeMessage> getLatestTweetsProvider =
    StreamProvider((ref) {
  final TweetApi tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getLatestTweet();
});

final StreamProvider<RealtimeMessage> getLatestNotificationsProvider =
    StreamProvider((ref) {
  final NotificationApi notificationApi = ref.watch(notificationApiProvider);
  return notificationApi.getNotificationsRealtime();
});

final FutureProviderFamily<TweetModel, String> getTweetByIdProvider =
    FutureProvider.family((ref, String tweetId) {
  final TweetController tweetController =
      ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetByTweetId(tweetId);
});

final searchControllerProvider = StateNotifierProvider((ref) {
  final userAPi = ref.watch(userApiProvider);
  return UserController(userApi: userAPi);
});

final FutureProviderFamily<List<UserModel>, String> searchUsersByNameProvider =
    FutureProvider.family((ref, String name) async {
  final users = await ref
      .watch(searchControllerProvider.notifier)
      .searchUsersByName(name);
  return users;
});

final FutureProviderFamily<List<TweetModel>, UserModel>
    getAllTweetsByUserProvider = FutureProvider.family((ref, UserModel user) {
  final TweetController tweetController =
      ref.watch(tweetControllerProvider.notifier);
  return tweetController.getAllTweetsByUser(user);
});

final FutureProviderFamily<List<TweetModel>, String>
    getTweetsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final TweetController tweetController =
      ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag);
});

final StreamProvider<RealtimeMessage> getUpdatedDetailsOfUserProvider =
    StreamProvider((ref) {
  final UserApi userApi = ref.watch(userApiProvider);
  return userApi.getUpdatedDetailsOfUser();
});

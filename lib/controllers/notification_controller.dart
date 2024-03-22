import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/api/notification_api.dart';
import 'package:titer/models/notification_model.dart';
import 'package:titer/ui/custom_widgets/snackbar.dart';

class NotificationController extends StateNotifier<bool> {
  final NotificationApi _notificationApi;

  NotificationController({required NotificationApi notificationApi})
      : _notificationApi = notificationApi,
        super(false);

  void createTweetNotification(
      {required String notificationType,
      required String notificationText,
      required String interactedToTweetOfuserId,
      required String interactedOntweetId,
      required BuildContext context}) async {
    final NotificationModel notification = NotificationModel(
      notificationId: '',
      notificationType: notificationType,
      notificationText: notificationText,
      interactedOntweetId: interactedOntweetId,
      interactedToTweetOfuserId: interactedToTweetOfuserId,
      followedBy: '',
      followed: '',
    );
    final res =
        await _notificationApi.createNotification(notification: notification);
    res.fold((l) {}, (r) {
      showSnackBar(context, r);
    });
  }

  void createFollowNotification(
      {required String notificationType,
      required String notificationText,
      required String followedBy,
      required String followed,
      required BuildContext context}) async {
    final NotificationModel notification = NotificationModel(
      notificationId: '',
      notificationType: notificationType,
      notificationText: notificationText,
      interactedOntweetId: '',
      interactedToTweetOfuserId: '',
      followedBy: followedBy,
      followed: followed,
    );
    final res =
        await _notificationApi.createNotification(notification: notification);
    res.fold((l) {}, (r) {
      showSnackBar(context, r);
    });
  }

  Future<List<NotificationModel>> getAllNotificationsOfUser(String uid) async {
    List<NotificationModel> notifications = [];
    final res = await _notificationApi.getAllNotificationsOfUser(uid);
    res.fold((docs) {
      notifications =
          docs.map((e) => NotificationModel.fromMap(e.data)).toList();
    }, (r) => null);
    return notifications;
  }
}

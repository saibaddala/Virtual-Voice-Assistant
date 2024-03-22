import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/appwrite_constants.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/notification_model.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ref.watch(getNotificationsOfUserProvider(user!.$id)).when(
          data: (notifications) {
            return ref.watch(getLatestNotificationsProvider).when(
                data: (newNotification) {
              if (newNotification.events.contains(
                  'databases.*.collections.${AppwriteConstants.notificationsCollectionId}.documents.*.create')) {
                notifications.insert(
                    0, NotificationModel.fromMap(newNotification.payload));
              }
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationTile(notification: notifications[index]);
                  });
            }, error: (error, stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            }, loading: () {
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationTile(notification: notifications[index]);
                  });
            });
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
          loading: () => const LoadingIndicator()),
    );
  }
}

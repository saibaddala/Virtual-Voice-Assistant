import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:titer/models/notification_model.dart';
import 'package:titer/ui/constants/assets_constants.dart';
import 'package:titer/ui/constants/pallete.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == 'follow'
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == 'like'
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  colorFilter:
                      const ColorFilter.mode(Pallete.redColor, BlendMode.srcIn),
                  height: 20,
                )
              : notification.notificationType == 'retweet'
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      colorFilter: const ColorFilter.mode(
                          Pallete.whiteColor, BlendMode.srcIn),
                      height: 20,
                    )
                  : null,
      title: Text(notification.notificationText),
    );
  }
}

import 'dart:convert';

class NotificationModel {
  final String notificationId;
  final String notificationType;
  final String notificationText;
  final String interactedOntweetId;
  final String interactedToTweetOfuserId;
  final String followedBy;
  final String followed;
  NotificationModel({
    required this.notificationId,
    required this.notificationType,
    required this.notificationText,
    required this.interactedOntweetId,
    required this.interactedToTweetOfuserId,
    required this.followedBy,
    required this.followed,
  });

  NotificationModel copyWith({
    String? notificationId,
    String? notificationType,
    String? notificationText,
    String? interactedOntweetId,
    String? interactedToTweetOfuserId,
    String? followedBy,
    String? followed,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      notificationType: notificationType ?? this.notificationType,
      notificationText: notificationText ?? this.notificationText,
      interactedOntweetId: interactedOntweetId ?? this.interactedOntweetId,
      interactedToTweetOfuserId:
          interactedToTweetOfuserId ?? this.interactedToTweetOfuserId,
      followedBy: followedBy ?? this.followedBy,
      followed: followed ?? this.followed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationType': notificationType,
      'notificationText': notificationText,
      'interactedOntweetId': interactedOntweetId,
      'interactedToTweetOfuserId': interactedToTweetOfuserId,
      'followedBy': followedBy,
      'followed': followed,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['\$id'] as String,
      notificationType: map['notificationType'] as String,
      notificationText: map['notificationText'] as String,
      interactedOntweetId: map['interactedOntweetId'] as String,
      interactedToTweetOfuserId: map['interactedToTweetOfuserId'] as String,
      followedBy: map['followedBy'] as String,
      followed: map['followed'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, notificationType: $notificationType, notificationText: $notificationText, interactedOntweetId: $interactedOntweetId, interactedToTweetOfuserId: $interactedToTweetOfuserId)';
  }
}

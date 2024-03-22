import 'dart:convert';
import 'package:flutter/material.dart';

@immutable
class TweetModel {
  final String uid;
  final String tweetId;
  final String tweetType;
  final String text;
  final DateTime tweetedAt;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final List<String> likes;
  final List<String> comments;
  final int retweetedCount;
  final String retweetedBy;
  final String repliedTo;
  const TweetModel({
    required this.uid,
    required this.tweetId,
    required this.tweetType,
    required this.text,
    required this.tweetedAt,
    required this.link,
    required this.hashtags,
    required this.imageLinks,
    required this.likes,
    required this.comments,
    required this.retweetedCount,
    required this.retweetedBy,
    required this.repliedTo,
  });

  TweetModel copyWith({
    String? uid,
    String? tweetId,
    String? tweetType,
    String? text,
    DateTime? tweetedAt,
    String? link,
    List<String>? hashtags,
    List<String>? imageLinks,
    List<String>? likes,
    List<String>? comments,
    int? retweetedCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return TweetModel(
      uid: uid ?? this.uid,
      tweetId: tweetId ?? this.tweetId,
      tweetType: tweetType ?? this.tweetType,
      text: text ?? this.text,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      imageLinks: imageLinks ?? this.imageLinks,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      retweetedCount: retweetedCount ?? this.retweetedCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'tweetType': tweetType,
      'text': text,
      'tweetedAt': tweetedAt.toIso8601String(),
      'link': link,
      'hashtags': hashtags,
      'imageLinks': imageLinks,
      'likes': likes,
      'comments': comments,
      'retweetedCount': retweetedCount,
      'retweetedBy': retweetedBy,
      'repliedTo': repliedTo,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      uid: map['uid'] as String,
      tweetId: map['\$id'] as String,
      tweetType: map['tweetType'] as String,
      text: map['text'] as String,
      tweetedAt: DateTime.parse(map['tweetedAt']),
      link: map['link'] as String,
      hashtags: List<String>.from(map['hashtags']),
      imageLinks: List<String>.from(map['imageLinks']),
      likes: List<String>.from(map['likes']),
      comments: List<String>.from(map['comments']),
      retweetedCount: map['retweetedCount'] as int,
      retweetedBy: map['retweetedBy'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TweetModel.fromJson(String source) =>
      TweetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TweetModel(uid: $uid, tweetId: $tweetId, tweetType: $tweetType, text: $text, tweetedAt: $tweetedAt, link: $link, hashtags: $hashtags, imageLinks: $imageLinks, likes: $likes, comments: $comments, retweetedCount: $retweetedCount,retweetedBy :$retweetedBy,repliedTo:$repliedTo)';
  }
}

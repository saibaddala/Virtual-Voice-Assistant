import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final String uid;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final List<String> followers;
  final List<String> following;
  final bool isTwitterBlue;
  const UserModel({
    required this.email,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.bannerPic,
    required this.bio,
    required this.followers,
    required this.following,
    required this.isTwitterBlue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'bio': bio,
      'followers': followers,
      'following': following,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      bannerPic: map['bannerPic'] as String,
      bio: map['bio'] as String,
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      isTwitterBlue: map['isTwitterBlue'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? email,
    String? name,
    String? uid,
    String? profilePic,
    String? bannerPic,
    String? bio,
    List<String>? followers,
    List<String>? following,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, uid: $uid, profilePic: $profilePic, bannerPic: $bannerPic, bio: $bio, followers: $followers, following: $following, isTwitterBlue: $isTwitterBlue)';
  }
}

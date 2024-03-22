import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/api/user_api.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/custom_widgets/snackbar.dart';

class UserController extends StateNotifier<bool> {
  final UserApi _userApi;

  UserController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  void saveUserDetails({required UserModel userModel}) async {
    await _userApi.saveUserDetails(userModel: userModel);
  }

  Future<UserModel> getUserDetails({required String uid}) async {
    final Document document = await _userApi.getUserDetails(uid: uid);
    final userModel = UserModel.fromMap(document.data);
    return userModel;
  }

  Future<List<UserModel>> searchUsersByName(String name) async {
    final docs = await _userApi.searchUsersByName(name);
    final List<UserModel> users =
        docs.map((e) => UserModel.fromMap(e.data)).toList();
    return users;
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required String profilePicUrl,
    required String bannerPicUrl,
  }) async {
    if (profilePicUrl.isNotEmpty) {
      userModel = userModel.copyWith(profilePic: profilePicUrl);
    }
    if (bannerPicUrl.isNotEmpty) {
      userModel = userModel.copyWith(bannerPic: bannerPicUrl);
    }
    final res = await _userApi.updateUserProfile(userModel: userModel);
    res.fold((successMsg) {
      showSnackBar(context, successMsg);
    }, (failureMsg) {
      showSnackBar(context, failureMsg);
    });
  }

  Future<bool> followOrunfollowUser(
      UserModel currUser, UserModel user, BuildContext context) async {
    bool follow = false;
    if (currUser.following.contains(user.uid)) {
      currUser.following.remove(user.uid);
      user.followers.remove(currUser.uid);
    } else {
      follow = true;
      currUser.following.add(user.uid);
      user.followers.add(currUser.uid);
    }

    final res = await _userApi.updateFollowingAndFollowers(
        currUser: currUser, user: user);
    bool isdone = false;
    res.fold((successMsg) {
      isdone = true;
      showSnackBar(context, successMsg);
    }, (failureMsg) {
      showSnackBar(context, failureMsg);
    });

    return isdone && follow;
  }
}

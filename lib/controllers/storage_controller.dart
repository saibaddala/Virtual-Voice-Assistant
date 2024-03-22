import 'dart:io';
import 'package:titer/api/storage_api.dart';
import 'package:titer/backend/appwrite_constants.dart';

class StorageController {
  final StorageApi _storageApi;

  StorageController({required StorageApi storageApi})
      : _storageApi = storageApi;

  Future<List<String>> storeImages(List<File> imageFiles) async {
    final List<String> imageIds = await _storageApi.uploadImages(imageFiles);
    List<String> imageLinks = [];
    for (final imageId in imageIds) {
      imageLinks.add(
        AppwriteConstants.getImageUrlFromImageId(imageId),
      );
    }
    return imageLinks;
  }

  Future<String> updateProfilePic({required File profilePic}) async {
    final String imgId =
        await _storageApi.uploadProfileImg(profileImgFile: profilePic);
    final String imgUrl = AppwriteConstants.getImageUrlFromImageId(imgId);

    return imgUrl;
  }

  Future<String> updateBannerPic({required File bannerPic}) async {
    final String imgId =
        await _storageApi.uploadBannerImg(bannerImgFile: bannerPic);
    final String imgUrl = AppwriteConstants.getImageUrlFromImageId(imgId);

    return imgUrl;
  }
}

import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:titer/backend/appwrite_constants.dart';

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> imagesIds = [];
    for (final file in imageFiles) {
      final imageFile = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: file.path,
        ),
      );
      imagesIds.add(imageFile.$id);
    }
    return imagesIds;
  }

  Future<String> uploadProfileImg({required File profileImgFile}) async {
    String imgId = '';
    final imgFile = await _storage.createFile(
      bucketId: AppwriteConstants.imagesBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: profileImgFile.path,
      ),
    );
    imgId = imgFile.$id;
    return imgId;
  }

  Future<String> uploadBannerImg({required File bannerImgFile}) async {
    String imgId = '';
    final imgFile = await _storage.createFile(
      bucketId: AppwriteConstants.imagesBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: bannerImgFile.path,
      ),
    );
    imgId = imgFile.$id;
    return imgId;
  }
}

class AppwriteConstants {
  static const String endPoint = "http://192.168.18.117/v1";
  static const String projectId = "65ccce215165ee299726";
  static const String databaseId = "65cce0e795b3f49f65a2";
  static const String usersCollectionId = "65cce10231b87bc4ceff";
  static const String tweetsCollectionId = "65d8142d6859e3d96225";
  static const String notificationsCollectionId = "65e14809d7456dd1a2ad";
  static const String imagesBucketId = "65e976efd74ecbf30971";

  static String getImageUrlFromImageId(String imageId) {
    return '$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
  }
}

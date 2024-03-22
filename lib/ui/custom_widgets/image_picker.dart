import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<List<File>> pickImages() async {
  List<File> pickedImages = [];
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> images = [];

  images = await imagePicker.pickMultiImage();

  for (final image in images) {
    pickedImages.add(File(image.path));
  }

  return pickedImages;
}

Future<File?> pickImage() async {
  File? pickedImage;
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;
  image = await imagePicker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    pickedImage = File(image.path);
  }
  return pickedImage;
}

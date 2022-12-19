import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  static ImageController get to => Get.find<ImageController>();


  RxString imagePath ="".obs;
  final _picker = ImagePicker();

  Future<v
    if (pickedFile != null) {
      imagePath = pickedFile.path.obs;
      update();
    } else {
      print('No image selected.');
    }oid> getGalleryImage() async {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imagePath = pickedFile.path.obs;
        update();
      } else {
        print('No image selected.');
      }
    } Future<void> getCameraImage() async {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);

    }
}
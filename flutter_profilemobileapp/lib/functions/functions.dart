import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileManagement {
}

class SocialsData {
  String key;
  String value;
  SocialsData({this.key = '', this.value = ''});
}

class FormFunctions {
  void _onRowChanged() {

  }
}

//deprecated class cus i cant make ts work
class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    return null;
  }
}
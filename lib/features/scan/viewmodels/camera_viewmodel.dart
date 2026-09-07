import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewModel extends ChangeNotifier {
  XFile? frontImage;
  XFile? backImage;

  Future<void> chooseFrontImage(ImageSource source) async {
    final picker = ImagePicker();

    frontImage = await picker.pickImage(source: source);

    notifyListeners();
  }

  Future<void> chooseBackImage(ImageSource source) async {
    final picker = ImagePicker();

    backImage = await picker.pickImage(source: source);

    notifyListeners();
  }

  void removeBackImage() {
    backImage = null;
    notifyListeners();
  }

  void removeFrontImage() {
   frontImage = null;
    notifyListeners();
  }

  void clearAllImages() {
    removeFrontImage();
    removeBackImage();
  }
}

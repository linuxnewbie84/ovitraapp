import "package:image_picker/image_picker.dart";

Future<XFile?> getImageC() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  return image;
}

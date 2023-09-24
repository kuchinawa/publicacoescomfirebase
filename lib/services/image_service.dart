import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String imagePath) async {
    try {
      final Reference storageReference = _storage.ref().child(imagePath);
      final UploadTask uploadTask = storageReference.putFile(imageFile);

      final TaskSnapshot storageSnapshot = await uploadTask;

      final String downloadURL = await storageSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }
}

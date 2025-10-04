import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfilePhoto(String userId, File file) async {
    try {
      var snapshot = await _storage
          .ref()
          .child('profile_photos/$userId')
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

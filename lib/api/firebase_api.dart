import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseApi {
  static Future<String?> uploadFile(File file) async {
    try {
      final ref = FirebaseStorage.instance.ref(basename(file.path));
      final uploadTask = await ref.putFile(file);
      final url = await (uploadTask).ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

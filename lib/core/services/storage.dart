import 'dart:io';
import 'dart:typed_data';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/user.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StorageService {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  // FirebaseStorage get storage => _storage;

  Future<FirebaseStorageResult> uploadPfp({ @required File imageToUpload, @required String uid }) async {
    final StorageReference storageRef = _storage.ref().child(uid);

    StorageUploadTask uploadTask = storageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if(uploadTask.isComplete) {
      String url = downloadUrl.toString();
      try {
        await locator<UserService>().updateUser(User(pfpUrl: url));
      } catch(err) {
        return FirebaseStorageResult(false);
      }
      return FirebaseStorageResult(true, imageUrl: url, imageFileName: uid);
    }
  }
  
  Future<FirebaseStorageResult> uploadImage({ @required Asset imageToUpload, @required String title }) async {

    String imageFileName = title + DateTime.now().millisecondsSinceEpoch.toString();
    
    ByteData byteData = await imageToUpload.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    final StorageReference firebaseStorageRef = _storage
      .ref()
      .child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putData(imageData);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return FirebaseStorageResult(
        true,
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    return FirebaseStorageResult(false);
  }

  // Future<FirebaseStorageResult> uploadImage({ @required File imageToUpload, @required String title }) async {

  //   String imageFileName = title + DateTime.now().millisecondsSinceEpoch.toString();

  //   final StorageReference firebaseStorageRef = _storage
  //   .ref()
  //   .child(imageFileName);

  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
  //   StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

  //   var downloadUrl = await storageSnapshot.ref.getDownloadURL();

  //   if (uploadTask.isComplete) {
  //     var url = downloadUrl.toString();
  //     return FirebaseStorageResult(
  //       true,
  //       imageUrl: url,
  //       imageFileName: imageFileName,
  //     );
  //   }
  //   return FirebaseStorageResult(false);
  // }
}

class FirebaseStorageResult {
  final String imageUrl;
  final String imageFileName;
  final bool success;

  FirebaseStorageResult(this.success, {this.imageUrl, this.imageFileName});
}
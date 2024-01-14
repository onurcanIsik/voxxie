// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voxxie/core/service/image/IImage.service.dart';

class ImageService implements IImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Future<Either<String, Unit>> getImage() async {
    // todo: implement getImage

    try {
      final XFile? pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final File imageFile = File(pickedImage.path);
        final imageUrl = await uploadImageToFirestore(imageFile);

        return right(unit);
      } else {
        return left("Something went wrong!");
      }
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }

  @override
  Future<Either<String, Unit>> uploadImageToFirestore(File imageFile) async {
    // todo: implement uploadImageToFirestore
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch.toString()}');

      await storageReference.putFile(imageFile);
      final String imageUrl = await storageReference.getDownloadURL();

      await _firestore.collection('Users').doc(userID).update({
        'userImage': imageUrl,
      });

      return right(unit);
    } catch (e) {
      return left(throw UnimplementedError());
    }
  }
}

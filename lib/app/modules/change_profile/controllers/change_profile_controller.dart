import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ChangeProfileController extends GetxController {
  late TextEditingController email;
  late TextEditingController name;
  late TextEditingController status;

  final ImagePicker imagePicker = ImagePicker();
  XFile? selectImage;

  void pickImage() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectImage = image;
      } else {
        print("Cancel");
      }
      update();
    } catch (error) {
      print(error);
      selectImage = null;
      update();
    }
  }

  void deleteImage() {
    selectImage = null;
    update();
  }

  final storage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<String?> upload(String uid) async {
    Reference storageRef = storage.ref("$uid.png");
    File file = File(selectImage!.path);
    try {
      final data = await storageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      final photoUrl = await storageRef.getDownloadURL();
      deleteImage();
      print(photoUrl);
      return photoUrl;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    name = TextEditingController();
    status = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    email.dispose();
    name.dispose();
    status.dispose();
    super.onClose();
  }
}

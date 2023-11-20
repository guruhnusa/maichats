import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController status;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    status = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    status.dispose();
    super.onClose();
  }

}

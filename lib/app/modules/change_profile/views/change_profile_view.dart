import 'dart:io';

import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constraint/color.dart';
import '../../../data/constraint/font_style.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final AuthCon = Get.find<AuthController>();

  ChangeProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.email.text = AuthCon.myUsers.value.email!;
    controller.name.text = AuthCon.myUsers.value.name!;
    controller.status.text = AuthCon.myUsers.value.status ?? "";

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Change Profile"),
          elevation: 0,
          backgroundColor: color4,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
              )),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Obx(() {
                  return Container(
                    height: 190,
                    width: 190,
                    color: Colors.red,
                    child: AuthCon.myUsers.value.photoUrl == "noimage"
                        ? Image.asset(
                      "assets/images/profile.png",
                      fit: BoxFit.contain,
                    )
                        : Image.network("${AuthCon.myUsers.value.photoUrl}",
                        fit: BoxFit.cover),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              readOnly: true,
              controller: controller.email,
              cursorColor: color1,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color2, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color1, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Email",
                  hintStyle: textRegular.copyWith(fontSize: 14),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.name,
              cursorColor: color1,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color2, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color1, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Name",
                  hintStyle: textRegular.copyWith(fontSize: 14),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.status,
              cursorColor: color1,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color2, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color1, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  hintText: "Update Status...",
                  hintStyle: textRegular.copyWith(fontSize: 14),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<ChangeProfileController>(builder: (controller) {
                  return controller.selectImage != null
                      ? Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(
                                File(controller.selectImage!.path),
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.deleteImage();
                              },
                              icon: Icon(Icons.delete, color: Colors.red,)),
                          TextButton(
                              onPressed: () async {
                                final updateProfile = await controller.upload(
                                    AuthCon.myUsers.value.uid!);
                                AuthCon.updatePhotoUrl(updateProfile!);
                              },
                              child: Text("Upload",
                                  style: textMedium.copyWith(
                                      color: Colors.black)))
                        ],
                      )
                    ],
                  )
                      : Text("No Image");
                }),
                TextButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    child: Text("Choose Image",
                        style: textSemibold.copyWith(color: Colors.black)))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: color3,
                ),
                onPressed: () {
                  final name = controller.name.text;
                  final status = controller.status.text;
                  AuthCon.changeProfile(name, status);
                },
                child: Text(
                  "Update Profile",
                  style:
                  textSemibold.copyWith(fontSize: 16, color: Colors.white),
                )),
          ],
        ));
  }
}

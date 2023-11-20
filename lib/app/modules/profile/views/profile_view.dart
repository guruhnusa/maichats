import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color4,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  authC.logout();
                },
                icon: Icon(
                  Icons.logout_rounded,
                ))
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 20,),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Obx(() {
                  return Container(
                    height: 190,
                    width: 190,
                    color: Colors.red,
                    child: authC.myUsers.value.photoUrl == "noimage"
                        ? Image.asset(
                      "assets/images/profile.png",
                      fit: BoxFit.contain,
                    )
                        : Image.network(
                        "${authC.myUsers.value.photoUrl}", fit: BoxFit.cover),
                  );
                }),
              ),
            ),
            Obx(
                  () =>
                  Center(
                    child: Text(
                      "${authC.myUsers.value.name}",
                      style: textMedium.copyWith(fontSize: 20),
                    ),
                  ),
            ),
            Center(
              child: Text(
                "${authC.myUsers.value.email}",
                style: textRegular.copyWith(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                title: Text("Update Status",
                    style: textRegular.copyWith(fontSize: 20)),
                leading: Icon(
                  Icons.note_add_rounded,
                  size: 30,
                  color: color2,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 25,
                  color: color1,
                ),
                onTap: () {
                  Get.toNamed(Routes.UPDATE_STATUS);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Change Profile",
                    style: textRegular.copyWith(fontSize: 20)),
                leading: Icon(
                  Icons.person,
                  size: 30,
                  color: color2,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 25,
                  color: color1,
                ),
                onTap: () {
                  Get.toNamed(Routes.CHANGE_PROFILE);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Change Theme",
                    style: textRegular.copyWith(fontSize: 20)),
                leading: Icon(
                  Icons.palette,
                  size: 30,
                  color: color2,
                ),
                trailing:
                Text("Light", style: textRegular.copyWith(fontSize: 16)),
                onTap: () {},
              ),
            ),
          ],
        ));
  }
}

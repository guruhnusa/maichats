import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              height: Get.width,
              width: Get.width,
              child:
                  Lottie.asset("assets/lottie/login.json", fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color3,
                ),
                onPressed: () {
                  authC.login();
                },
                child: Text(
                  "Sign In With Google",
                  style: textSemibold.copyWith(fontSize: 16,color: Colors.white),
                )),
          ),
        ],
      ),
    ));
  }
}

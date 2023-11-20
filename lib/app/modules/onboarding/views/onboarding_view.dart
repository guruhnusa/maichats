import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  final AuthCon = Get.find<AuthController>();

  OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: controller.PageView,
      showSkipButton: true,
      skip: Text(
        "Skip",
        style: textMedium.copyWith(fontSize: 16, color: Colors.black),
      ),
      next: Text(
        "Next",
        style: textMedium.copyWith(fontSize: 16, color: Colors.black),
      ),
      done: Text(
        "Login",
        style: textSemibold.copyWith(fontSize: 16, color: Colors.black),
      ),
      onDone: () {
        Get.offAllNamed(Routes.LOGIN);
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: color1,
        color: color2,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    ));
  }
}

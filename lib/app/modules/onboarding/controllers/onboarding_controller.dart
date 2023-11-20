import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../data/constraint/font_style.dart';

class OnboardingController extends GetxController {

  List<PageViewModel> PageView =
    [
      PageViewModel(
        decoration: PageDecoration(
            titleTextStyle: textBold.copyWith(fontSize: 20),
            bodyTextStyle: textRegular.copyWith(fontSize: 16)),
        title: "Welcome to Chats App",
        body:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        image: Center(
          child: Container(
              height: Get.width * 0.6,
              width: Get.width * 0.6,
              child: Lottie.asset("assets/lottie/onboarding1.json")),
        ),
      ),
      PageViewModel(
        decoration: PageDecoration(
            titleTextStyle: textBold.copyWith(fontSize: 20),
            bodyTextStyle: textRegular.copyWith(fontSize: 16)),
        title: "Hello Please Enjoy Using This App",
        body:
        "ELorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        image: Center(
          child: Container(
              height: Get.width * 0.6,
              width: Get.width * 0.6,
              child: Lottie.asset("assets/lottie/onboarding2.json")),
        ),
      ),
      PageViewModel(
        decoration: PageDecoration(
            titleTextStyle: textBold.copyWith(fontSize: 20),
            bodyTextStyle: textRegular.copyWith(fontSize: 16)),
        title: "Share with your friends",
        body:
        "Lorem Ipsum is simply dummy text of the  and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
        image: Center(
          child: Container(
              height: Get.width * 0.6,
              width: Get.width * 0.6,
              child: Lottie.asset("assets/lottie/onboarding3.json")),
        ),
      ),
    ];

}

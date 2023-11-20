import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/utils/error_screen.dart';
import 'package:chatapps/app/utils/loading_screen.dart';
import 'package:chatapps/app/utils/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final authCon = Get.put(AuthController(), permanent: true);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(authCon.isSkip.value);
          print(authCon.isAuth.value);
          return Obx(
                () {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Chat Apps",
                initialRoute: authCon.isSkip.isTrue
                    ? authCon.isAuth.isTrue
                    ? Routes.HOME
                    : Routes.LOGIN
                    : Routes.ONBOARDING,
                getPages: AppPages.routes,
              );
            },
          );
        }
        return FutureBuilder(
          future: authCon.firstIntitialize(),
          builder: (context, snapshot) {
            return SplashScreen();
          },
        );
      },
    );
  }
}

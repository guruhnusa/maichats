import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constraint/font_style.dart';
import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  final AuthCon = Get.find<AuthController>();

   UpdateStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.status.text =  AuthCon.myUsers.value.status ?? "";

    return Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Status"),
        elevation: 0,
        backgroundColor: color4,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_rounded,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.status,
            cursorColor: color1,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color2, width: 2),
                  borderRadius: BorderRadius.circular(15)
              ),
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
          SizedBox(height: 30,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                backgroundColor: color3,
              ),
              onPressed: () {
                AuthCon.updateStatus(controller.status.text);
              },
              child: Text(
                "Update Status",
                style: textSemibold.copyWith(fontSize: 16),
              )),
        ],
      )
    );
  }
}

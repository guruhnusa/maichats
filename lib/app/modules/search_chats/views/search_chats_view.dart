import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_chats_controller.dart';

class SearchChatsView extends GetView<SearchChatsController> {
  final authC = Get.find<AuthController>();
  SearchChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: AppBar(
            backgroundColor: color2,
            title: Text('Search', style: textMedium),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_rounded),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onChanged: (value) {
                    controller.searchFriend(value, authC.myUsers.value.email!);
                  },
                  controller: controller.search,
                  cursorColor: color1,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color1, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {},
                          child: Icon(
                            Icons.search_outlined,
                            color: color4,
                          )),
                      hintText: "Search Friends..",
                      hintStyle: textRegular.copyWith(fontSize: 14),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => controller.tempSearch.isEmpty
              ? Center(
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.width * 0.7,
                    child: Lottie.asset("assets/lottie/empty.json"),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) {
                    final FriendEmail = controller.tempSearch[index]["email"];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(200),
                          child: SizedBox(
                            child: controller.tempSearch[index]["photoUrl"] == "noimage"
                                ? Image.asset(
                              "assets/images/profile.png",
                              fit: BoxFit.contain,
                            )
                                : Image.network("${controller.tempSearch[index]["photoUrl"]}",fit: BoxFit.contain),
                          ),
                        ),
                        title: Text(
                            "${controller.tempSearch[index]["name"]}",
                            style: textSemibold.copyWith(fontSize: 18)),
                        subtitle: Text("${FriendEmail}",
                            style: textRegular.copyWith(fontSize: 14),maxLines: 1,overflow:TextOverflow.ellipsis ),
                        trailing: GestureDetector(
                            onTap: () {
                              authC.addNewConnection(FriendEmail);
                            },
                            child: Chip(
                                label: Text(
                              "Message",
                              style: textRegular,
                            ))),
                      ),
                    );
                  },
                ),
        ));
  }
}

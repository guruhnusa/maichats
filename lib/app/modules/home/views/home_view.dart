import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 90,
            width: Get.width,
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: textSemibold.copyWith(fontSize: 35, color: color2),
                  ),
                  Material(
                    color: color4,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person,
                          size: 35,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatStream(authC.myUsers.value.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocChats = snapshot1.data?.docs;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: listDocChats?.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller
                            .friendsStream(listDocChats?[index]["connection"]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot2.data!.data();
                            return data!["status"] == ""
                                ? ListTile(
                                    onTap: () {
                                      controller.gotoChatRooms(
                                          listDocChats![index].id,
                                          authC.myUsers.value.email!,
                                          listDocChats[index]["connection"]);
                                    },
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black26,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: data["photoUrl"] == "noimage"
                                            ? Image.asset(
                                                "assets/logo/noimage.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${data["photoUrl"]}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    title: Text(data["name"]),
                                    trailing: listDocChats?[index]
                                                ["total_unread"] ==
                                            0
                                        ? const SizedBox()
                                        : Chip(
                                            label: Text(
                                                "${listDocChats?[index]["total_unread"]}"),
                                          ),
                                  )
                                : ListTile(
                                    onTap: () {
                                      controller.gotoChatRooms(
                                          listDocChats![index].id,
                                          authC.myUsers.value.email!,
                                          listDocChats[index]["connection"]);
                                    },
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black26,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: data["photoUrl"] == "noimage"
                                            ? Image.asset(
                                                "assets/logo/noimage.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${data["photoUrl"]}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    title: Text(data["name"]),
                                    subtitle: Text(
                                      data["status"],
                                    ),
                                    trailing: listDocChats?[index]
                                                ["total_unread"] ==
                                            0
                                        ? const SizedBox()
                                        : Chip(
                                            label: Text(
                                                "${listDocChats?[index]["total_unread"]}"),
                                          ),
                                  );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: color4,
          onPressed: () {
            Get.toNamed(Routes.SEARCH_CHATS);
          },
          child: const Icon(Icons.message_rounded)),
    );
  }
}

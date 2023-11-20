
import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/data/constraint/color.dart';
import 'package:chatapps/app/data/constraint/font_style.dart';
import 'package:chatapps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chats_room_controller.dart';

class ChatsRoomView extends GetView<ChatsRoomController> {
  final authCon = Get.find<AuthController>();
  Map<String, dynamic> data = Get.arguments;

  ChatsRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chat_id = data["chat_id"];
    final friendEmail = data["friendEmail"];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: color4,
          leadingWidth: 110,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.HOME);
                  },
                  icon: const Icon(Icons.arrow_back_rounded)),
              CircleAvatar(
                backgroundColor: color4,
                radius: 25,
                child: StreamBuilder<DocumentSnapshot<dynamic>>(
                  stream: controller.friendDataStream(friendEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data =
                          snapshot.data?.data() as Map<String, dynamic>;
                      if (data["[photoUrl"] == "noimage") {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                              image: AssetImage("assets/images/profile.png"),
                              fit: BoxFit.cover),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: NetworkImage(data["photoUrl"]),
                            fit: BoxFit.cover),
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                          image: AssetImage("assets/images/profile.png"),
                          fit: BoxFit.cover),
                    );
                  },
                ),
              )
            ],
          ),
          title: StreamBuilder<DocumentSnapshot<dynamic>>(
              stream: controller.friendDataStream(friendEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final data = snapshot.data?.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data["name"],
                          style: textMedium.copyWith(fontSize: 18)),
                      Text(
                        data["status"],
                        style: textRegular.copyWith(fontSize: 13),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
        body: PopScope(
          onPopInvoked: (didPop) {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.chatStream(chat_id),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.docs;
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (data!.isNotEmpty) {
                        return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("${data[index]["groupTime"]}"),
                                  BubbleChats(
                                      isSender: data[index]["sender"] ==
                                              authCon.myUsers.value.email
                                          ? true
                                          : false,
                                      message: data[index]["message"],
                                      time: data[index]["time"])
                                ],
                              );
                            } else {
                              if (data[index]["groupTime"] ==
                                  data[index - 1]["groupTime"]) {
                                return BubbleChats(
                                    isSender: data[index]["sender"] ==
                                            authCon.myUsers.value.email
                                        ? true
                                        : false,
                                    message: data[index]["message"],
                                    time: data[index]["time"]);
                              } else {
                                return Column(
                                  children: [
                                    Text("${data[index]["groupTime"]}"),
                                    BubbleChats(
                                        isSender: data[index]["sender"] ==
                                                authCon.myUsers.value.email
                                            ? true
                                            : false,
                                        message: data[index]["message"],
                                        time: data[index]["time"])
                                  ],
                                );
                              }
                            }
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: controller.isShowEmoji.isTrue
                        ? 1
                        : context.mediaQueryPadding.bottom),
                child: Container(
                  width: Get.width,
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            autocorrect: false,
                            onEditingComplete: () {
                              controller.newChat(authCon.myUsers.value.email!,
                                  friendEmail, chat_id, controller.chatsC.text);
                            },
                            controller: controller.chatsC,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: color2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: color2, width: 1)),
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.focusNode.unfocus();
                                    controller.isShowEmoji.toggle();
                                  },
                                  icon: const Icon(
                                    Icons.emoji_emotions_rounded,
                                    color: color3,
                                  ),
                                  iconSize: 30),
                            ),
                            focusNode: controller.focusNode,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            controller.newChat(authCon.myUsers.value.email!,
                                friendEmail, chat_id, controller.chatsC.text);
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: color3,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.send,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmoji(emoji);
                        },
                        onBackspacePressed: () {
                          controller.delEmoji();
                        },
                        config: const Config(
                          columns: 7,
                          emojiSizeMax: 32,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: color1,
                          iconColor: Colors.grey,
                          iconColorSelected: color1,
                          backspaceColor: color1,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          noRecents: Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ));
  }
}

class BubbleChats extends StatelessWidget {
  const BubbleChats({
    required this.isSender,
    required this.message,
    required this.time,
    super.key,
  });

  final bool isSender;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: isSender
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                  color: color2),
              padding: const EdgeInsets.all(12),
              child: Text("${message}",
                  style:
                      textRegular.copyWith(fontSize: 14, color: Colors.white))),
          const SizedBox(
            height: 5,
          ),
          Text("${DateFormat.jm().format(DateTime.parse(time))}",
              style: textRegular.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

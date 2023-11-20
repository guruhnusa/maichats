import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsRoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isShowEmoji = false.obs;

  late FocusNode focusNode;
  late TextEditingController chatsC;
  late ScrollController scrollC;

  void addEmoji(Emoji emoji) {
    chatsC.text = chatsC.text + emoji.emoji;
  }

  void delEmoji() {
    chatsC.text = chatsC.text.substring(0, chatsC.text.length - 2);
  }

  var total_unread = 0;

  void newChat(
      String email, String friendEmail, String chat_id, String message) async {
    if (message != "") {
      CollectionReference chats = firestore.collection("chats");
      CollectionReference users = firestore.collection("users");

      String time = DateTime.now().toIso8601String();

      await chats.doc(chat_id).collection("chat").add({
        "sender": email,
        "receiver": friendEmail,
        "message": message,
        "time": time,
        "isRead": false,
        "groupTime" :  DateFormat.yMMMMd('en_US').format(DateTime.parse(time))
      });

      Timer(Duration.zero, () {
        scrollC.jumpTo(scrollC.position.maxScrollExtent);
      });

      chatsC.clear();
      await users
          .doc(email)
          .collection("chats")
          .doc(chat_id)
          .update({"lastTime": time});

      final checkChatsFriend =
          await users.doc(friendEmail).collection("chats").doc(chat_id).get();

      if (checkChatsFriend.exists) {
        //ada data chat di temen kita
        // first check total unread
        final checkTotalUnread = await chats
            .doc(chat_id)
            .collection('chat')
            .where("isRead", isEqualTo: false)
            .where("sender", isEqualTo: email)
            .get();

        //total unread friend user
        total_unread = checkTotalUnread.docs.length;

        await users
            .doc(friendEmail)
            .collection("chats")
            .doc(chat_id)
            .update({"lastime": time, "total_unread": total_unread});
      } else {
        //new chat for friend database
        await users.doc(friendEmail).collection("chats").doc(chat_id).set({
          "connection": email,
          "lastTime": time,
          "total_unread": total_unread + 1,
        });
      }
    }
  }

  @override
  void onInit() {
    scrollC = ScrollController();
    chatsC = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollC.dispose();
    chatsC.dispose();
    focusNode.dispose();
    super.onClose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String chat_id) {
    CollectionReference chats = firestore.collection("chats");
    return chats
        .doc(chat_id)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Stream<DocumentSnapshot<Object?>> friendDataStream(String email){
    CollectionReference users = firestore.collection("users");
    return users.doc(email).snapshots();
  }



}

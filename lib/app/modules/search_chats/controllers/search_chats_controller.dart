import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchChatsController extends GetxController {
  late TextEditingController search;

  @override
  void onInit() {
    search = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    print("SEARCH FRIEND $data");
    if (data.isEmpty) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalize = data.substring(0, 1).toUpperCase() + data.substring(1);
      print("KAPITAL = $capitalize");
      if (queryAwal.isEmpty && data.length == 1) {
        //Function yang dijalankan ketikan huruf pertama
        CollectionReference users = await firestore.collection("users");
        final keynameResult = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: email)
            .get();
        print("TOTAL DATA : ${keynameResult.docs.length}");
        if (keynameResult.docs.length > 0) {
          for (int i = 0; i < keynameResult.docs.length; i++) {
            queryAwal.add(keynameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("Query result ${queryAwal}");
        } else {
          print("NO QUERY RESULT");
        }
      }

      if (queryAwal.length != 0) {
        tempSearch.value = [];
        queryAwal.forEach((element) {
          print(element);
          if (element["name"].startsWith(capitalize)) {
            tempSearch.add(element);
          }
        });
      }
    }
    queryAwal.refresh();
    tempSearch.refresh();
  }
}

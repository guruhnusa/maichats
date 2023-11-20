import 'package:chatapps/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/users_model.dart';

class AuthController extends GetxController {
  var isSkip = false.obs;
  var isAuth = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  late UserCredential userCredential;

  var myUsers = UsersModel().obs;

  Future<void> firstIntitialize() async {
    final login = await autoLogin();
    if (login == true) {
      isAuth.value = true;
    }
    final skip = await skipOnboard();
    if (skip == true) {
      isSkip.value = true;
    }
  }

  Future<bool> autoLogin() async {
    //mengubah isAuth => true = autologin
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn == true) {
        final auto = await _googleSignIn.signInSilently();
        _currentUser = auto;
        final googleAuth = await _currentUser?.authentication;
        print("BERHASIL AUTO LOGIN");
        print("${_currentUser}");
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print(userCredential);
        await addFirestore(
          "${_currentUser!.displayName}",
          "${_currentUser!.email}",
          "${_currentUser!.photoUrl ?? "noimage"}",
          "${userCredential.user!.metadata.creationTime!.toIso8601String()}",
          "${userCredential.user!.uid}",
          "${userCredential.user!.metadata.lastSignInTime!.toIso8601String()}",
        );
        return true;
      }
      return false;
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<bool> skipOnboard() async {
    //megunah skip => true
    final box = GetStorage();
    if (box.read("skipOnboarding") != null ||
        box.read("skipOnboarding") == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login() async {
    try {
      // handle kebocoran data user
      await _googleSignIn.signOut();
      _currentUser = await _googleSignIn.signIn();
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn == true) {
        final googleAuth = await _currentUser?.authentication;
        print("BERHASIL LOGIN");
        print("${_currentUser}");
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print(userCredential);
        //simpan status user pernah login ke local memori untuk skip onboarding
        final box = GetStorage();
        if (box.read("skipOnboarding") != null) {
          box.remove("skipOnboarding");
        }
        box.write('skipOnboarding', true);
        //Add to firestore
        await addFirestore(
          "${_currentUser!.displayName}",
          "${_currentUser!.email}",
          "${_currentUser!.photoUrl ?? "noimage"}",
          "${userCredential.user!.metadata.creationTime!.toIso8601String()}",
          "${userCredential.user!.uid}",
          "${userCredential.user!.metadata.lastSignInTime!.toIso8601String()}",
        );

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("GAGAL LOGIN");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    isAuth.value = false;
    print("BERHASIL LOGOUT");
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> addFirestore(String name, String email, String photo,
      String creationTime, String uid, String lastSignInTime) async {
    CollectionReference users = firestore.collection('users');
    try {
      final checkUser = await users.doc(email).get();
      if (checkUser.data() == null) {
        await users.doc(email).set(
          {
            'uid': uid,
            'name': name.substring(0, 1).toUpperCase() + name.substring(1),
            'keyName': name.substring(0, 1).toUpperCase(),
            'email': email,
            'photoUrl': photo,
            'status': "",
            'creationTime': creationTime,
            'lastSignInTime': lastSignInTime,
            'updatedTime': DateTime.now().toIso8601String(),
          },
        );
        users.doc(email).collection("chats");
        print("Success Add New User to Database");
      } else {
        await users.doc(email).update({
          'lastSignInTime': lastSignInTime,
        });

        print("Succes Logins");
      }
      final theUser = await users.doc(email).get();
      final theUserData = theUser.data() as Map<String, dynamic>;

      myUsers(UsersModel.fromJson(theUserData));
      myUsers.refresh();

      final listChats = await users.doc(email).collection("chats").get();

      if (listChats.docs.isNotEmpty) {
        List<ChatUser> dataListChats = [];
        listChats.docs.forEach((element) {
          var dataDocChats = element.data();
          var dataDocChatsId = element.id;
          dataListChats.add(ChatUser(
            chatId: dataDocChatsId,
            connection: dataDocChats["connection"],
            lastTime: dataDocChats["lastTime"],
            total_unread: dataDocChats["total_unread"],
          ));
        });

        myUsers.update((user) {
          user!.chats = dataListChats;
        });
      } else {
        myUsers.update((user) {
          user!.chats = [];
        });
      }
    } catch (error) {
      print(error);
    }
    myUsers.refresh();
  }

  //PROFILE
  void changeProfile(String name, String status) {
    final updatedTime = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    try {
      users.doc(_currentUser?.email).update({
        'keyName': name.substring(0, 1).toUpperCase(),
        'name': name.substring(0, 1).toUpperCase() + name.substring(1),
        'status': status,
        "updatedTime": updatedTime,
      });
      myUsers.update((val) {
        myUsers.value.keyName = name.substring(0, 1).toUpperCase();
        myUsers.value.name =
            name.substring(0, 1).toUpperCase() + name.substring(1);
        myUsers.value.status = status;
        myUsers.value.updatedTime = updatedTime;
      });
      myUsers.refresh();
      Get.defaultDialog(
        title: "Change Profile",
        middleText: "Success Change Profile",
      );
      print("Berhasil Change Profile");
    } catch (error) {
      print(error);
    }
  }

  void updateStatus(String status) {
    final updatedTime = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    try {
      users.doc(_currentUser?.email).update({
        'status': status,
        "updatedTime": updatedTime,
      });
      myUsers.update((val) {
        myUsers.value.status = status;
        myUsers.value.updatedTime = updatedTime;
      });
      myUsers.refresh();
      Get.defaultDialog(
        title: "Update Status",
        middleText: "Success Update Status",
      );
      print("Berhasil Update Status");
    } catch (error) {
      print(error);
    }
  }

  //Search
  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        // sudah pernah buat koneksi dengan => friendEmail
        flagNewConnection = false;

        //chat_id from chats collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // blm pernah buat koneksi dengan => friendEmail
        // buat koneksi ....
        flagNewConnection = true;
      }
    } else {
      // blm pernah chat dengan siapapun
      // buat koneksi ....
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      // cek dari chats collection => connections => mereka berdua...
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          myUsers.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          myUsers.update((user) {
            user!.chats = [];
          });
        }

        chat_id = chatDataId;

        myUsers.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          myUsers.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          myUsers.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        myUsers.refresh();
      }
    }
    final updateStatusChats = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("receiver", isEqualTo: _currentUser?.email)
        .get();

    updateStatusChats.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(_currentUser?.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});


    Get.toNamed(Routes.CHATS_ROOM, arguments: {
      "chat_id": chat_id,
      "friendEmail": friendEmail,
    });
  }

  void updatePhotoUrl(String photoUrl) async{
    final updatedTime = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    try {
      users.doc(_currentUser?.email).update({
        "photoUrl": photoUrl,
        "updatedTime" : updatedTime,
      });
      myUsers.update((val) {
        val?.photoUrl = photoUrl;
        val?.updatedTime = updatedTime;
      });
      myUsers.refresh();
    } catch (error) {
      print(error);
    }
  }
}

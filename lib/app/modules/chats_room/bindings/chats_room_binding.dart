import 'package:get/get.dart';

import '../controllers/chats_room_controller.dart';

class ChatsRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatsRoomController>(
      () => ChatsRoomController(),
    );
  }
}

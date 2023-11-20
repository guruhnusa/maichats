import 'package:get/get.dart';

import '../controllers/search_chats_controller.dart';

class SearchChatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchChatsController>(
      () => SearchChatsController(),
    );
  }
}

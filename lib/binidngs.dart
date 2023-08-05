import 'package:flutter_video_player/player_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PlayerController());
  }
}

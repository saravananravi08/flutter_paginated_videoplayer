import 'package:flutter/material.dart';
import 'package:flutter_video_player/model.dart';
import 'package:get/get.dart';
import 'package:better_player/better_player.dart';
import 'api_service.dart';

class PlayerController extends GetxController {
  int reelOffset = 0;
  int reelLimit = 16;
  @override
  void onInit() async {
    await getData();
    super.onInit();
  }

  RxList<Result> reelsList = <Result>[].obs;
  final List<BetterPlayerController> betterPlayerControllerRegistry = [];
  final List<BetterPlayerController> usedBetterPlayerControllerRegistry = [];

  Future getData() async {
    String endpoint = '/reels/list/';
    final parameters = {'limit': reelLimit, 'offset': reelOffset};
    await ApiServices()
        .getMethod(endpoint, parameters: parameters)
        .then((value) {
      var result = ReelModel.fromJson(value.data);
      reelsList.addAll(result.results);

      // for (var d in result.results) {
      //   reusableVideoListController(d);
      // }
      debugPrint('${betterPlayerControllerRegistry.length}');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }

  reusableVideoListController(Result reel) {
    for (int index = 0; index < 4; index++) {
      betterPlayerControllerRegistry.add(
        BetterPlayerController(
          betterPlayerDataSource: BetterPlayerDataSource.network(reel.video),
          const BetterPlayerConfiguration(
              looping: true,
              allowedScreenSleep: false,
              handleLifecycle: false,
              autoDispose: false),
        ),
      );
    }
  }

  BetterPlayerController? getBetterPlayerController() {
    final freeController = betterPlayerControllerRegistry.firstWhereOrNull(
        (controller) =>
            !usedBetterPlayerControllerRegistry.contains(controller));

    if (freeController != null) {
      usedBetterPlayerControllerRegistry.add(freeController);
    }

    return freeController;
  }

  void freeBetterPlayerController(
      BetterPlayerController? betterPlayerController) {
    usedBetterPlayerControllerRegistry.remove(betterPlayerController);
  }

  @override
  void onClose() {
    for (var controller in betterPlayerControllerRegistry) {
      controller.dispose();
    }
    super.onClose();
  }
}

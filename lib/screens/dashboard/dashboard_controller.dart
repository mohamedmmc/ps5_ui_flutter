import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps5_ui_flutter/data/games_data.dart';
import 'package:ps5_ui_flutter/models/game.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  final activeTab = Rx<ContentType>(ContentType.game);
  final selectedGameId = games[0].id.obs;
  final selectedMediaId = mediaApps[1].id.obs;

  late AnimationController fadeController;

  @override
  void onInit() {
    super.onInit();
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fadeController.forward();
  }

  List<Game> get currentList => activeTab.value == ContentType.game ? games : mediaApps;

  String get currentId => activeTab.value == ContentType.game ? selectedGameId.value : selectedMediaId.value;

  Game get selectedItem => currentList.firstWhere(
        (g) => g.id == currentId,
        orElse: () => currentList[0],
      );

  void handleSelect(String id) {
    if (activeTab.value == ContentType.game) {
      selectedGameId.value = id;
    } else {
      selectedMediaId.value = id;
    }
    // Restart fade animation for background change
    fadeController.reset();
    fadeController.forward();
  }

  void handleTabChange(ContentType tab) {
    activeTab.value = tab;
  }

  @override
  void onClose() {
    fadeController.dispose();
    super.onClose();
  }
}

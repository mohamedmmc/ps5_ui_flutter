import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps5_ui_flutter/data/games_data.dart';
import 'package:ps5_ui_flutter/models/game.dart';
import 'dart:async';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  final activeTab = Rx<ContentType>(ContentType.game);
  final selectedGameId = games[0].id.obs;
  final selectedMediaId = mediaApps[1].id.obs;
  final currentTime = ''.obs;

  Timer? _timer;

  late AnimationController fadeController;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fadeController.forward();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    currentTime.value = '$hour:$minute';
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
  }

  void handleTabChange(ContentType tab) {
    activeTab.value = tab;
  }

  @override
  void onClose() {
    _timer?.cancel();
    fadeController.dispose();
    super.onClose();
  }
}

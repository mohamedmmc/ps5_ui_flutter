import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class UserSelectController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final currentTime = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.forward();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    currentTime.value = '$hour:$minute';
  }

  @override
  void onClose() {
    _timer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}

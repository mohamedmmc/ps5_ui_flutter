import 'package:get/get.dart';
import 'dart:async';

class UserSelectController extends GetxController {
  final currentTime = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
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
    super.onClose();
  }
}

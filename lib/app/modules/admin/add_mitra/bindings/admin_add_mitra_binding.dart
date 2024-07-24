import 'package:get/get.dart';

import '../controllers/admin_add_mitra_controller.dart';

class AdminAddMitraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAddMitraController>(
      () => AdminAddMitraController(),
    );
  }
}

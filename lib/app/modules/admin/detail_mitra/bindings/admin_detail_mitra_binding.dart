import 'package:get/get.dart';

import '../controllers/admin_detail_mitra_controller.dart';

class AdminDetailMitraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDetailMitraController>(
      () => AdminDetailMitraController(),
    );
  }
}

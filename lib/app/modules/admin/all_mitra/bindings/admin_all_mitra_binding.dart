import 'package:get/get.dart';

import '../controllers/admin_all_mitra_controller.dart';

class AdminAllMitraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAllMitraController>(
      () => AdminAllMitraController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/parking_profile_update_controller.dart';

class ParkingProfileUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingProfileUpdateController>(
      () => ParkingProfileUpdateController(),
    );
  }
}

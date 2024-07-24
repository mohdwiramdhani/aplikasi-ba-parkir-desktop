import 'package:get/get.dart';

import '../controllers/parking_slot_layout_controller.dart';

class ParkingSlotLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingSlotLayoutController>(
      () => ParkingSlotLayoutController(),
    );
  }
}

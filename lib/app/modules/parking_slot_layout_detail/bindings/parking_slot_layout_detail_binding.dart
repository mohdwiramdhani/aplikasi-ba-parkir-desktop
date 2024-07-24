import 'package:get/get.dart';

import '../controllers/parking_slot_layout_detail_controller.dart';

class ParkingSlotLayoutDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingSlotLayoutDetailController>(
      () => ParkingSlotLayoutDetailController(),
    );
  }
}

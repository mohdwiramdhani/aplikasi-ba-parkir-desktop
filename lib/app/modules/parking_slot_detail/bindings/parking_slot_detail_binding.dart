import 'package:get/get.dart';

import '../controllers/parking_slot_detail_controller.dart';

class ParkingSlotDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingSlotDetailController>(
      () => ParkingSlotDetailController(),
    );
  }
}

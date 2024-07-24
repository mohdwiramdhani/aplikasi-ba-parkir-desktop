import 'package:get/get.dart';

import '../controllers/parking_slot_layout_detail_coordinate_controller.dart';

class ParkingSlotLayoutDetailCoordinateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingSlotLayoutDetailCoordinateController>(
      () => ParkingSlotLayoutDetailCoordinateController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/parking_visitor_controller.dart';

class ParkingVisitorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingVisitorController>(
      () => ParkingVisitorController(),
    );
  }
}

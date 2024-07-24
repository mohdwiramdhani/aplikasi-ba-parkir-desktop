import 'package:get/get.dart';

import '../controllers/parking_price_controller.dart';

class ParkingPriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingPriceController>(
      () => ParkingPriceController(),
    );
  }
}

import 'package:get/get.dart';

import '../modules/admin/add_mitra/bindings/admin_add_mitra_binding.dart';
import '../modules/admin/add_mitra/views/admin_add_mitra_view.dart';
import '../modules/admin/all_mitra/bindings/admin_all_mitra_binding.dart';
import '../modules/admin/all_mitra/views/admin_all_mitra_view.dart';
import '../modules/admin/detail_mitra/bindings/admin_detail_mitra_binding.dart';
import '../modules/admin/detail_mitra/views/admin_detail_mitra_view.dart';
import '../modules/admin/home/bindings/admin_home_binding.dart';
import '../modules/admin/home/views/admin_home_view.dart';
import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/light/bindings/light_binding.dart';
import '../modules/light/views/light_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/parking/bindings/parking_binding.dart';
import '../modules/parking/views/parking_view.dart';
import '../modules/parking_detail/bindings/parking_detail_binding.dart';
import '../modules/parking_detail/views/parking_detail_view.dart';
import '../modules/parking_price/bindings/parking_price_binding.dart';
import '../modules/parking_price/views/parking_price_view.dart';
import '../modules/parking_profile_update/bindings/parking_profile_update_binding.dart';
import '../modules/parking_profile_update/views/parking_profile_update_view.dart';
import '../modules/parking_slot/bindings/parking_slot_binding.dart';
import '../modules/parking_slot/views/parking_slot_view.dart';
import '../modules/parking_slot_detail/bindings/parking_slot_detail_binding.dart';
import '../modules/parking_slot_detail/views/parking_slot_detail_view.dart';
import '../modules/parking_slot_layout/bindings/parking_slot_layout_binding.dart';
import '../modules/parking_slot_layout/views/parking_slot_layout_view.dart';
import '../modules/parking_slot_layout_detail/bindings/parking_slot_layout_detail_binding.dart';
import '../modules/parking_slot_layout_detail/controllers/parking_slot_layout_detail_controller.dart';
import '../modules/parking_slot_layout_detail/views/parking_slot_layout_detail_view.dart';
import '../modules/parking_slot_layout_detail_coordinate/bindings/parking_slot_layout_detail_coordinate_binding.dart';
import '../modules/parking_slot_layout_detail_coordinate/views/parking_slot_layout_detail_coordinate_view.dart';
import '../modules/parking_visitor/bindings/parking_visitor_binding.dart';
import '../modules/parking_visitor/views/parking_visitor_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_update/bindings/profile_update_binding.dart';
import '../modules/profile_update/views/profile_update_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.adminHome,
      page: () => const AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.adminAllMitra,
      page: () => const AdminAllMitraView(),
      binding: AdminAllMitraBinding(),
    ),
    GetPage(
      name: _Paths.adminAddMitra,
      page: () => const AdminAddMitraView(),
      binding: AdminAddMitraBinding(),
    ),
    GetPage(
      name: _Paths.adminDetailMitra,
      page: () => AdminDetailMitraView(),
      binding: AdminDetailMitraBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.parking,
      page: () => const ParkingView(),
      binding: ParkingBinding(),
    ),
    GetPage(
      name: _Paths.camera,
      page: () => CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: _Paths.profileUpdate,
      page: () => const ProfileUpdateView(),
      binding: ProfileUpdateBinding(),
    ),
    GetPage(
      name: _Paths.parkingPrice,
      page: () => ParkingPriceView(),
      binding: ParkingPriceBinding(),
    ),
    GetPage(
      name: _Paths.parkingSlot,
      page: () => ParkingSlotView(),
      binding: ParkingSlotBinding(),
    ),
    GetPage(
      name: _Paths.parkingProfileUpdate,
      page: () => ParkingProfileUpdateView(),
      binding: ParkingProfileUpdateBinding(),
    ),
    GetPage(
      name: _Paths.parkingSlotDetail,
      page: () => ParkingSlotDetailView(),
      binding: ParkingSlotDetailBinding(),
    ),
    GetPage(
      name: _Paths.light,
      page: () => const LightView(),
      binding: LightBinding(),
    ),
    GetPage(
      name: _Paths.parkingSlotLayout,
      page: () => ParkingSlotLayoutView(),
      binding: ParkingSlotLayoutBinding(),
    ),
    GetPage(
      name: _Paths.parkingSlotLayoutDetail,
      page: () => ParkingSlotLayoutDetailView(),
      binding: ParkingSlotLayoutDetailBinding(),
    ),
    GetPage(
      name: _Paths.parkingSlotLayoutDetailCoordinate,
      page: () => ParkingSlotLayoutDetailCoordinateView(
        controller: ParkingSlotLayoutDetailController(),
      ),
      binding: ParkingSlotLayoutDetailCoordinateBinding(),
    ),
    GetPage(
      name: _Paths.parkingVisitor,
      page: () => ParkingVisitorView(),
      binding: ParkingVisitorBinding(),
    ),
    GetPage(
      name: _Paths.parkingDetail,
      page: () => ParkingDetailView(),
      binding: ParkingDetailBinding(),
    ),
  ];
}

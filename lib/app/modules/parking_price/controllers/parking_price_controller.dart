import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ParkingPriceController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt priceC = 500.obs; // Inisialisasi harga mobil dengan 500 rupiah
  // RxInt priceMotorC = 500.obs; // Inisialisasi harga motor dengan 500 rupiah

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> updateProfile(String uid) async {
    // DocumentReference<Map<String, dynamic>> colParking =
    //     firestore.collection("mitras").doc(uid);

    if (priceC.value != null) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "price": priceC.value,
          // "priceMotor": priceMotorC.value,
        };

        await firestore.collection("mitras").doc(uid).update(data);

        Get.back();
        Get.snackbar("Berhasil", "Berhasil perbarui tarif parkir");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat perbarui tarif parkir");
      } finally {
        isLoading.value = false;
      }
    } else {
      // Jika data tidak tersedia, berikan nilai default
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "price": 500, // Harga default jika tidak ada data
          // "priceMotor": 500, // Harga default jika tidak ada data
        };

        await firestore.collection("mitras").doc(uid).update(data);

        Get.back();
        Get.snackbar("Berhasil", "Berhasil perbarui tarif parkir");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat perbarui tarif parkir");
      } finally {
        isLoading.value = false;
      }
    }
  }
}

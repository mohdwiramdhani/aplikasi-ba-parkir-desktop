import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi_ba_parkir_desktop/app/modules/widget/map_selection_screen.dart';

class ParkingProfileUpdateController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController addressC = TextEditingController();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
    } else {}
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        addressC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
          "phone": phoneC.text,
          "address": addressC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.path.split(".").last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection("mitras").doc(uid).update(data);
        Get.back();
        Get.snackbar("Berhasil", "berhasil update profile");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> selectLocationOnMap() async {
    // Navigasi ke halaman peta menggunakan Navigator
    final LatLng? selectedLocation =
        await Get.to<LatLng?>(MapSelectionScreen());

    // Cek apakah pengguna memilih lokasi atau tidak
    if (selectedLocation != null) {
      // Lakukan sesuatu dengan lokasi yang dipilih, misalnya, atur nilai alamat
      addressC.text =
          "(${selectedLocation.latitude}, ${selectedLocation.longitude})";
    }
  }
}

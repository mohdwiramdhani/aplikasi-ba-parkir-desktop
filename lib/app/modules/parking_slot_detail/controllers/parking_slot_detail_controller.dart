import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingSlotDetailController extends GetxController {
  RxBool isLoading = false.obs;
  var selectedFloor = "Lantai 1".obs; // Menggunakan RxString

  List<String> floorOptions = [
    "Basement",
    "Lantai 1",
    "Lantai 2",
    "Lantai 3",
    "Lantai 4",
    "Lantai 5",
    "Rooftop"
  ];
  final TextEditingController codeSlotC = TextEditingController();
  String sloty = "aa";

  // final TextEditingController positionSlotC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> isSlotExists(
      String uid, String codeSlot, String positionSlot) async {
    final CollectionReference<Map<String, dynamic>> colParking =
        firestore.collection("mitras").doc(uid).collection("slot");

    final QuerySnapshot<Map<String, dynamic>> snapshot = await colParking
        .where("codeSlot", isEqualTo: codeSlot.toUpperCase())
        .get();

    if (snapshot.docs.isNotEmpty) {
      return true; // Kode slot sudah ada
    }

    return false; // Kode slot dan posisi slot belum ada
  }

  Future<bool> isPositionExists(String positionSlot) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> colParking =
        FirebaseFirestore.instance
            .collection("mitras")
            .doc(uid)
            .collection("slot");

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await colParking.where("positionSlot", isEqualTo: positionSlot).get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> addSlot(String positionSlot) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colParking =
        firestore.collection("mitras").doc(uid).collection("slot");

    if (codeSlotC.text.isNotEmpty && selectedFloor.value.isNotEmpty) {
      isLoading.value = true;

      // Mengonversi codeSlot ke huruf besar (uppercase)
      String codeSlotUppercase = codeSlotC.text.toUpperCase();

      // Memeriksa apakah kode slot atau posisi slot sudah ada
      final bool isCodeSlotExists =
          await isSlotExists(uid, codeSlotC.text, positionSlot);

      if (isCodeSlotExists) {
        Get.snackbar("Kesalahan", "Kode Slot atau Posisi Slot sudah ada.");
        isLoading.value = false;
        return;
      }

      try {
        Map<String, dynamic> data = {
          "codeSlot": codeSlotUppercase,
          "floorSlot": selectedFloor.value,
          "positionSlot": positionSlot,
          "status": "off",
        };

        await colParking.doc(positionSlot).set(data);

        Get.back();
        Get.snackbar(
            "Berhasil", "Berhasil menambahkan slot kode $codeSlotUppercase");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat menambahkan slot");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Kesalahan", "Harap isi semua field terlebih dahulu.");
    }
  }

  Future<void> deleteSlot(String positionSlot) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> colParking = FirebaseFirestore
          .instance
          .collection("mitras")
          .doc(uid)
          .collection("slot");

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await colParking.where("positionSlot", isEqualTo: positionSlot).get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs[0].id;
        await colParking.doc(docId).delete();
        Get.snackbar(
            "Berhasil", "Berhasil menghapus slot posisi $positionSlot");
      } else {
        Get.snackbar(
            "Kesalahan", "Slot dengan posisi $positionSlot tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "Tidak dapat menghapus slot: $e");
    }
  }
}

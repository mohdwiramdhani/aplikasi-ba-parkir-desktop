import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingSlotLayoutDetailController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController codeSlotC = TextEditingController();
  // Tambahkan variabel x1y1, x2y2, x3y3, dan x4y4
  Offset? x1y1, x2y2, x3y3, x4y4;

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

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Map<String, dynamic> offsetToJson(Offset? offset) {
    if (offset == null) {
      return {'dx': 0, 'dy': 0};
    }
    return {'dx': offset.dx.toInt(), 'dy': offset.dy.toInt()};
  }

  Offset offsetFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Offset.zero;
    }
    return Offset((json['dx'] ?? 0).toDouble(), (json['dy'] ?? 0).toDouble());
  }

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

    if (codeSlotC.text.isNotEmpty &&
        selectedFloor.value.isNotEmpty &&
        x1y1 != null &&
        x2y2 != null &&
        x3y3 != null &&
        x4y4 != null) {
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
          "x1y1": offsetToJson(x1y1),
          "x2y2": offsetToJson(x2y2),
          "x3y3": offsetToJson(x3y3),
          "x4y4": offsetToJson(x4y4),
          "status": "off",
          "plat": "",
          "dateOn": "",
          "timeOn": "",
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

  Future<void> fetchCodeSlotByPosition(String positionSlot) async {
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> colParking = FirebaseFirestore
          .instance
          .collection("mitras")
          .doc(uid)
          .collection("slot");

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await colParking.where("positionSlot", isEqualTo: positionSlot).get();

      if (snapshot.docs.isNotEmpty) {
        // Jika slot ditemukan, ambil codeSlot
        String codeSlot = snapshot.docs[0]["codeSlot"];
        // Set nilai codeSlotC.text
        codeSlotC.text = codeSlot;
      } else {
        // Jika slot tidak ditemukan, mungkin atur sesuai kebutuhan Anda
        codeSlotC.text = ""; // Set kosong atau sesuai kebutuhan
      }
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "Tidak dapat mengambil codeSlot: $e");
    }
  }
}

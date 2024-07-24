import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingSlotController extends GetxController {
  List<int> positionList = [];
  List<String> codeList = [];
  List<String> statusList = []; // Tambahkan list status
  List<String> platList = [];

  final TextEditingController messageC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchDataFromFirestore() async {
    String uid = auth.currentUser!.uid;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("mitras")
          .doc(uid)
          .collection("slot")
          .get();

      List<int> positionSlotdata = snapshot.docs.map((doc) {
        return int.parse(doc["positionSlot"].toString());
      }).toList();

      List<String> codeSlotData = snapshot.docs.map((doc) {
        return doc["codeSlot"].toString();
      }).toList();

      List<String> statusSlotData = snapshot.docs.map((doc) {
        return doc["status"].toString();
      }).toList();

      List<String> platSlotData = snapshot.docs.map((doc) {
        return doc["plat"].toString();
      }).toList();

      positionList = positionSlotdata;
      codeList = codeSlotData;
      statusList = statusSlotData; // Simpan statusSlot dalam statusList
      platList = platSlotData;
    } catch (e) {
      // Handle error
    }
  }

  Stream<Map<int, Map<String, String>>> positionListStream() {
    String uid = auth.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("mitras")
        .doc(uid)
        .collection("slot")
        .snapshots()
        .map((snapshot) {
      final Map<int, Map<String, String>> positionData = {};

      for (var doc in snapshot.docs) {
        int position = int.parse(doc["positionSlot"].toString());
        String codeSlot = doc["codeSlot"].toString();
        String status = doc["status"].toString();
        String dateOn = doc["dateOn"].toString();
        String timeOn = doc["timeOn"].toString();
        String plat = doc["plat"].toString();

        // Filter hanya untuk status "on" dan "off"
        if (status == "on" || status == "off") {
          positionData[position] = {
            "codeSlot": codeSlot,
            "status": status,
            "dateOn": dateOn,
            "timeOn": timeOn,
            "plat": plat,
          };
        }
      }

      return positionData;
    });
  }

  Stream<Map<String, dynamic>> totalEntranceStream() {
    String uid = "h08P4LepcqgAy0OmVROZxI0ppIw1";
    return FirebaseFirestore.instance
        .collection("mitras")
        .doc(uid)
        .collection("parking")
        .where("status", isEqualTo: "Masuk") // Filter hanya status "Masuk"
        .snapshots()
        .map((snapshot) {
      int entranceData = snapshot.size;
      return {"jumlahMasuk": entranceData}; // Ganti kunci dengan "jumlahMasuk"
    });
  }

  Stream<Map<String, dynamic>> totalSlotStream() {
    String uid = "h08P4LepcqgAy0OmVROZxI0ppIw1";
    return FirebaseFirestore.instance
        .collection("mitras")
        .doc(uid)
        .collection("slot")
        .snapshots()
        .map((snapshot) {
      int slotData = snapshot.size;
      return {"jumlahSlot": slotData}; // Ganti kunci dengan "jumlahSlot"
    });
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> streamParking() {
  //   String mitraID = auth.currentUser!.uid; // Ganti dengan id mitra yang sesuai

  //   return FirebaseFirestore.instance
  //       .collection('mitras')
  //       .doc(mitraID)
  //       .collection('parking')
  //       .where('status', isEqualTo: 'Masuk')
  //       .snapshots();
  // }

  Stream<Map<String, dynamic>> streamParking() {
    String mitraId = auth.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('mitras')
        .doc(mitraId)
        .collection('parking')
        .where('status', isEqualTo: 'Masuk')
        .snapshots()
        .map((snapshot) {
      final List<Map<String, dynamic>> parkingList = [];

      for (var doc in snapshot.docs) {
        // Disesuaikan dengan struktur data yang Anda butuhkan
        Map<String, dynamic> parkingData = {
          'plate': doc['plate'] ?? '',
          'uid': doc['userUID'] ?? '',
          'phone': doc['phone'] ?? ''
          // Tambahkan field lain sesuai kebutuhan
        };
        parkingList.add(parkingData);
      }

      return {
        'parkingList': parkingList,
      };
    });
  }

  void sendMessage(String uid) async {
    String message = messageC.text;


    // Dapatkan referensi koleksi 'users' untuk pengguna tertentu
    CollectionReference<Map<String, dynamic>> usersCollectionRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('parking');

    // Dapatkan referensi subkoleksi 'parking' dengan dokumen yang memenuhi kondisi
    Query<Map<String, dynamic>> parkingQuery =
        usersCollectionRef.where('status', isEqualTo: 'Masuk');

    // Ambil snapshot dari query
    QuerySnapshot<Map<String, dynamic>> parkingQuerySnapshot =
        await parkingQuery.get();

    // Iterasi melalui dokumen yang memenuhi kondisi dan perbarui pesan
    for (QueryDocumentSnapshot<Map<String, dynamic>> parkingDocSnapshot
        in parkingQuerySnapshot.docs) {
      // Perbarui subkoleksi 'parking' dengan pesan baru
      await parkingDocSnapshot.reference.update({
        'message': message,
        // Tambahkan field lain sesuai kebutuhan
      });
    }

    // Bersihkan nilai di TextField setelah pesan terkirim
    messageC.clear();
  }
}

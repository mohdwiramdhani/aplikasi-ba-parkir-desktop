import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ParkingSlotLayoutController extends GetxController {
  List<int> positionList = [];
  List<String> codeList = []; // Tambahkan list codeSlot

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

      positionList = positionSlotdata;
      codeList = codeSlotData; // Simpan codeSlot dalam codeList

      // Cetak kode slot ke konsol
    } catch (e) {
      // print(positionList);
    }
  }

  Stream<List<int>> positionListStream() {
    String uid = auth.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("mitras")
        .doc(uid)
        .collection("slot")
        .snapshots()
        .map((snapshot) {
      final positionSlotdata = snapshot.docs.map((doc) {
        return int.parse(doc["positionSlot"].toString());
      }).toList();

      final codeSlotData = snapshot.docs.map((doc) {
        return doc["codeSlot"].toString();
      }).toList();

      positionList = positionSlotdata;
      codeList = codeSlotData; // Simpan codeSlot dalam codeList

      return positionSlotdata;
    });
  }
}

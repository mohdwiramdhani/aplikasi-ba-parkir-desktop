import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class HomeController extends GetxController {
  RxBool isSwitched = false.obs;
  RxBool pythonScriptExecuted = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseDatabase database = FirebaseDatabase.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("mitras").doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamParking() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection("mitras")
        .doc(uid)
        .collection("parking")
        .doc("price")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamParkingSlot() {
    String uid = auth.currentUser!.uid;

    return firestore
        .collection("mitras")
        .doc(uid)
        .collection("slot")
        .snapshots();
  }

  void openEntranceGate() {
    String uid = auth.currentUser!.uid;
    Uri url = Uri.parse(
        "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app/entranceGate.json");

    Map<String, dynamic> data = {
      uid: {"value": 1},
    };

    http.put(url, body: json.encode(data));
  }

  void closeEntranceGate() {
    String uid = auth.currentUser!.uid;
    Uri url = Uri.parse(
        "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app/entranceGate.json");

    Map<String, dynamic> data = {
      uid: {"value": 90},
    };

    http.put(url, body: json.encode(data));
  }

  Stream<Map<String, dynamic>> streamEntranceGateData() async* {
    String uid = auth.currentUser!.uid;
    dio.Dio dioClient = dio.Dio(); // Use 'dio.Dio' with the alias
    String endpoint =
        "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app/entranceGate/$uid.json";

    while (true) {
      try {
        dio.Response response =
            await dioClient.get(endpoint); // Use 'dio.Response' with the alias
        var data = response.data;
        yield data as Map<String, dynamic>;
      } catch (e) {
        //
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void openExitGate() {
    String uid = auth.currentUser!.uid;
    Uri url = Uri.parse(
        "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app/exitGate.json");

    Map<String, dynamic> data = {
      uid: {"value": 90},
    };

    http.put(url, body: json.encode(data));
  }

  void closeExitGate() {
    String uid = auth.currentUser!.uid;
    Uri url = Uri.parse(
        "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app/exitGate.json");

    Map<String, dynamic> data = {
      uid: {"value": 1},
    };

    http.put(url, body: json.encode(data));
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

  Future<Map<String, dynamic>> logout() async {
    late FirebaseAuth auth = FirebaseAuth.instance; // Inisialisasi FirebaseAuth
    try {
      await auth.signOut();
      return {"error": false, "message": "Berhasil logout"};
    } on FirebaseAuthException catch (e) {
      return {"error": true, "message": "${e.message}"};
    } catch (e) {
      return {"error": true, "message": "Tidak dapat logout"};
    }
  }

  Future<void> runPythonScript() async {
    pythonScriptExecuted.value = true;
    String currentUserUid = auth.currentUser!.uid;
    await Process.run(
      'python',
      ['python/flutter.py', currentUserUid],
    );
  }
}

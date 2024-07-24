import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ParkingVisitorController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Tambahkan variabel filter
  RxString filter = 'Semua'.obs;

  // Fungsi untuk mengatur filter
  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  // Fungsi untuk mendapatkan data parkir dengan filter
  Stream<QuerySnapshot<Object?>> getParkingData() {
    String uid = auth.currentUser!.uid;

    // Gunakan filter untuk mengatur query
    Query parkingQuery =
        firestore.collection('mitras').doc(uid).collection('parking');

    // Jika filter bukan 'Semua', tambahkan kondisi ke query
    if (filter.value != 'Semua') {
      parkingQuery = parkingQuery.where('status', isEqualTo: filter.value);
    }

    // Kembalikan data stream
    return parkingQuery.snapshots();
  }

  // Fungsi untuk mengubah status dan filter
  void changeStatusAndFilter(String newStatus) {
    // Atur status
    setStatus(newStatus);

    // Sesuaikan filter berdasarkan status
    if (newStatus == 'Masuk') {
      setFilter('Masuk');
    } else if (newStatus == 'Keluar') {
      setFilter('Keluar');
    } else {
      setFilter('Semua');
    }
  }

  // Fungsi untuk mengatur status (gantilah ini sesuai kebutuhan)
  void setStatus(String newStatus) {
    // Implementasi sesuai kebutuhan, misalnya:
    // status.value = newStatus;
  }
}

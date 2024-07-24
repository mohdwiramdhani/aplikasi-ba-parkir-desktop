import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("mitras").doc(uid).snapshots();
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
}

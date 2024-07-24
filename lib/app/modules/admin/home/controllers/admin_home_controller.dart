import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
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

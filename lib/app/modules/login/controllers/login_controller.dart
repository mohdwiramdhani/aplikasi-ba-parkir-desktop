import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );

        if (userCredential.user != null) {
          //verif email
          // if (userCredential.user!.emailVerified == false) {
          String userUid = userCredential.user!.uid;

          final String userRole = await fetchUserRoleFromFirestore(userUid);
          final String adminRole = await fetchAdminRoleFromFirestore(userUid);

          if (userRole == "mitra") {
            Get.offAllNamed(Routes.home);
          } else if (adminRole == "admin") {
            Get.offAllNamed(Routes.adminHome);
          } else {
            Get.snackbar("Terjadi kesalahan", "Pengguna tidak ditemukan.");
          }
          // } else {
          //   Get.defaultDialog(
          //     title: "Notifikasi",
          //     middleText: "Anda belum melakukan verifikasi email.",
          //     actions: [
          //       OutlinedButton(
          //         onPressed: () => Get.back(),
          //         child: const Text("Batal"),
          //       ),
          //       ElevatedButton(
          //         onPressed: () async {
          //           try {
          //             await userCredential.user!.sendEmailVerification();
          //             Get.back();
          //             Get.snackbar(
          //               "Berhasil",
          //               "Email verifikasi berhasil dikirim, cek email anda.",
          //             );
          //           } catch (e) {
          //             Get.snackbar(
          //               "Terjadi kesalahan",
          //               "Gagal melakukan verifikasi email.",
          //             );
          //           }
          //         },
          //         child: const Text("Kirim"),
          //       ),
          //     ],
          //   );
          // }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi kesalahan", "Pengguna tidak ditemukan.");
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          Get.snackbar("Terjadi kesalahan", "Email atau password salah.");
        } else if (e.code == 'invalid-email') {
          Get.snackbar("Terjadi kesalahan", "Alamat email tidak valid.");
        }
      } catch (e) {
        Get.snackbar("Terjadi kesalahan",
            "Gagal melakukan login, silahkan hubungin admin.");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Email dan password wajib diisi");
    }
  }

  Future<String> fetchUserRoleFromFirestore(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('mitras').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('role')) {
          return data['role'];
        }
      }
      return 'user';
    } catch (e) {
      return 'user';
    }
  }

  Future<String> fetchAdminRoleFromFirestore(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('admins').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('role')) {
          return data['role'];
        }
      }
      return 'user';
    } catch (e) {
      return 'user';
    }
  }
}

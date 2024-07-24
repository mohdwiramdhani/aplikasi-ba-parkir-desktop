// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddMitraController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> proccesAddMitra() async {
    if (passwordAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passwordAdminC.text);

        UserCredential mitraCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "mitra123");

        if (mitraCredential.user != null) {
          String? uid = mitraCredential.user!.uid;

          await firestore.collection("mitras").doc(uid).set({
            "name": nameC.text,
            "address": addressC.text,
            "phone": phoneC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "mitra",
            "createAt": DateTime.now().toIso8601String(),
          });

          // await mitraCredential?.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passwordAdminC.text);
          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Berhasil menambahkan mitra parkir");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi kesalahan", "Password terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi kesalahan", "Email sudah ada");
        } else if (e.code == "wrong-password") {
          Get.snackbar(
              "Terjadi kesalahan", "Admin tidak dapat login, password salah");
        } else if (e.code == "unknown-error") {
          Get.snackbar("Terjadi kesalahan", "Password salah");
        } else {
          Get.snackbar("Terjadi kesalahan", e.code);
        }
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat menambahkan mitra.");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Password wajib isi");
    }
  }

  void addMitra() async {
    if (nameC.text.isNotEmpty &&
        addressC.text.isNotEmpty &&
        phoneC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi admin",
          content: Column(
            children: [
              const Text("Masukkan password untuk validasi admin"),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
                onPressed: () async {
                  proccesAddMitra();
                },
                child: const Text("Tambah")),
          ]);
    } else {
      Get.snackbar("Terjadi kesalahan", "Data wajib isi");
    }
  }
}

import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parking_controller.dart';

class ParkingView extends GetView<ParkingController> {
  const ParkingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KONTROL PARKIR'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}";
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            user["profile"] != null
                                ? user["profile"] != ""
                                    ? user["profile"]
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            user['name'].toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${user['email']}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(
                      Routes.parkingProfileUpdate,
                      arguments: user,
                    ),
                    child: const Text("Profil Parkir"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(
                      Routes.parkingPrice,
                      arguments: user,
                    ),
                    child: const Text("Tarif Parkir"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(
                      Routes.parkingSlot,
                      arguments: user,
                    ),
                    child: const Text("Slot Parkir"),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text("Tidak dapa memuat data user"),
              );
            }
          }),
    );
  }
}

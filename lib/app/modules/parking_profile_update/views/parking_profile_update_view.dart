import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parking_profile_update_controller.dart';

class ParkingProfileUpdateView extends GetView<ParkingProfileUpdateController> {
  final Map<String, dynamic> user = Get.arguments;

  ParkingProfileUpdateView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.nameC.text = user["name"];
    controller.phoneC.text = user["phone"];
    controller.emailC.text = user["email"];
    controller.addressC.text = user["address"];
    String defaultImage = "https://ui-avatars.com/api/?name=${user['name']}";
    return Scaffold(
      appBar: AppBar(
        title: const Text('UBAH PROFIL'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            keyboardType: TextInputType.name,
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Nama Lokasi",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.phone,
            // readOnly: true,
            controller: controller.phoneC,
            decoration: const InputDecoration(
              labelText: "Nomor Telepon",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.streetAddress,
            controller: controller.addressC,
            decoration: InputDecoration(
              labelText: "Alamat",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  // Tambahkan fungsi untuk menangani interaksi ikon peta di sini
                  controller.selectLocationOnMap();
                },
                icon: const Icon(Icons
                    .place), // Gantilah 'my_icon' dengan ikon yang diinginkan
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Foto Profil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<ParkingProfileUpdateController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user["profile"] != null) {
                      return ClipOval(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            user["profile"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    {
                      return ClipOval(
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
                      );
                    }
                  }
                },
              ),
              OutlinedButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text("Pilih File"),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                },
                // child: Text("send reset password"),
                child:
                    Text(controller.isLoading.isFalse ? "SIMPAN" : "LOADING"),
              )),
        ],
      ),
    );
  }
}

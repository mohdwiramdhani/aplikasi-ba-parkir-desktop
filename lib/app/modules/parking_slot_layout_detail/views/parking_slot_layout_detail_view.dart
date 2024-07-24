import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';

import '../controllers/parking_slot_layout_detail_controller.dart';

class ParkingSlotLayoutDetailView
    extends GetView<ParkingSlotLayoutDetailController> {
  ParkingSlotLayoutDetailView({super.key});
  final number = Get.arguments;

  @override
  Widget build(BuildContext context) {
    String positionSlot = number.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Posisi $number'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.codeSlotC,
            decoration: const InputDecoration(
              labelText: "Kode Slot",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => DropdownButtonFormField(
              value: controller.selectedFloor.value,
              onChanged: (newValue) {
                // Ketika opsi lantai dipilih
                controller.selectedFloor.value = newValue!;
              },
              items: controller.floorOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  enabled: value != "Basement" &&
                      value != "Lantai 2" &&
                      value != "Lantai 3" &&
                      value != "Lantai 4" &&
                      value != "Lantai 5" &&
                      value != "Rooftop",
                  child: value == "Basement" ||
                          value == "Lantai 2" ||
                          value == "Lantai 3" ||
                          value == "Lantai 4" ||
                          value == "Lantai 5" ||
                          value == "Rooftop"
                      ? Text(value, style: const TextStyle(color: Colors.grey))
                      : Text(value), // Nonaktifkan opsi yang tidak diinginkan
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Lantai",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    // Panggil fungsi untuk menampilkan dialog dengan frame kamera
                    var result = await Get.toNamed(
                        Routes.parkingSlotLayoutDetailCoordinate);

                    // Cek apakah result tidak null dan berisi data yang diharapkan
                    if (result != null) {
                      // Lakukan sesuatu dengan data dari View Kedua
                      // Cetak masing-masing nilai dari result

                      controller.x1y1 = result['x1y1'];
                      controller.x2y2 = result['x2y2'];
                      controller.x3y3 = result['x3y3'];
                      controller.x4y4 = result['x4y4'];
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(
                      16.0,
                    ), // Sesuaikan dengan jumlah padding yang diinginkan
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons
                          .place_outlined), // Ganti ikon dengan ikon peta atau ikon lainnya
                      SizedBox(
                        width: 8,
                      ), // Berikan sedikit jarak dengan ikon
                      Text(
                        "Atur Koordinat Slot",
                      ), // Tekstual untuk tombol
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              controller.addSlot(positionSlot);
            },
            child: const Text("SIMPAN"),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<bool>(
            future: controller.isPositionExists(positionSlot),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi Hapus"),
                          content: const Text(
                              "Apakah Anda yakin ingin menghapus slot ini?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteSlot(positionSlot);
                                Get.back();
                                Get.back();
                              },
                              child: const Text("Ya"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("HAPUS"), // Warna tombol merah
                );
              } else {
                return const SizedBox(); // Tidak menampilkan tombol jika posisi tidak ada
              }
            },
          )
        ],
      ),
    );
  }
}

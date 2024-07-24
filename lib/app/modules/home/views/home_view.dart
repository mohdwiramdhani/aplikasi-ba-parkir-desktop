import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Color getColorForPercentage(double percentage) {
    if (percentage >= 0.9) {
      return Colors.red;
    } else if (percentage >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapUser) {
              if (snapUser.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<String, dynamic> user = snapUser.data!.data()!;

              return Row(
                children: [
                  const Icon(Icons.person_2_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Selamat Datang, ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: user["name"].toString().length > 20
                              ? '${user["name"].toString().substring(0, 20)}...'
                              : user["name"],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                Map<String, dynamic> hasil = await controller.logout();
                if (hasil["error"] == false) {
                  Get.offAllNamed(Routes.login);
                } else {
                  Get.snackbar("error", hasil["message"]);
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Column 1
                  SizedBox(
                    width: 600,
                    height: 300,
                    child: Expanded(
                      child: Card(
                        // Isi card Column 1
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: StreamBuilder<Map<String, dynamic>>(
                                  stream: controller.streamEntranceGateData(),
                                  builder: (context, snapParking) {
                                    // if (snapParking.connectionState ==
                                    //     ConnectionState.waiting) {
                                    //   return const Center(
                                    //     child: CircularProgressIndicator(),
                                    //   );
                                    // }

                                    var data = snapParking.data;
                                    var status = data?["status"];
                                    var name = data?["userName"];
                                    var vehicle = data?["userVehicle"];
                                    var plate = data?["userPlate"];

                                    // Cek apakah data tidak null
                                    if (status == null &&
                                        name == null &&
                                        vehicle == null &&
                                        plate == null) {
                                      // Jika semua data null, return widget kosong (tanpa tampilan)
                                      return const SizedBox.shrink();
                                    }

                                    return Column(
                                      children: [
                                        if (status != null)
                                          Text(
                                            "$status",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32,
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        if (name != null)
                                          Text(
                                            "Nama: $name",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        if (vehicle != null)
                                          Text(
                                            "Kendaraan: $vehicle",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        if (plate != null)
                                          Text(
                                            "Plat Nomor: $plate",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamUser(),
                                  builder: (context, snapParking) {
                                    if (snapParking.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    Map<String, dynamic>? dataParking =
                                        snapParking.data?.data();

                                    return Column(
                                      children: [
                                        const Text(
                                          "Tarif Parkir",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            dataParking?['price'] != null
                                                ? 'Mobil : Rp ${NumberFormat.decimalPattern('id_ID').format(dataParking?['price'])}'
                                                : "Mobil : Rp 0",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(
                                              8.0), // Sesuaikan padding sesuai kebutuhan
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .black, // Sesuaikan warna garis kotak
                                              width:
                                                  2.0, // Sesuaikan ketebalan garis kotak
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Sesuaikan radius sudut garis kotak
                                          ),
                                          child: Text(
                                            dataParking?['balance'] != null
                                                ? "Saldo : Rp. ${dataParking?['balance'].toString().replaceAllMapped(
                                                      RegExp(
                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                      (Match match) =>
                                                          '${match[1]},',
                                                    )}"
                                                : "Saldo : Rp. 0",
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Column 2
                  SizedBox(
                    width: 600,
                    height: 300,
                    child: Card(
                      // Isi card Column 2
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Palang Masuk
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Kontrol Palang Masuk',
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              const Divider(),
                              ElevatedButton(
                                onPressed: () {
                                  // Logika untuk tombol buka palang masuk
                                  controller.openEntranceGate();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100,
                                      50), // Atur lebar dan tinggi sesuai kebutuhan Anda
                                ),
                                child: const Text('Buka'),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Logika untuk tombol tutup palang masuk
                                  controller.closeEntranceGate();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100,
                                      50), // Atur lebar dan tinggi sesuai kebutuhan Anda
                                ),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),

                          // Garis pemisah
                          const VerticalDivider(),

                          // Palang Keluar
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Kontrol Palang Keluar',
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              const Divider(),
                              ElevatedButton(
                                onPressed: () {
                                  // Logika untuk tombol buka palang masuk
                                  controller.openExitGate();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100,
                                      50), // Atur lebar dan tinggi sesuai kebutuhan Anda
                                ),
                                child: const Text('Buka'),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Logika untuk tombol tutup palang masuk
                                  controller.closeExitGate();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100,
                                      50), // Atur lebar dan tinggi sesuai kebutuhan Anda
                                ),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 700,
                    height: 250,
                    child: Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<Map<String, dynamic>>(
                                stream: rx.Rx.combineLatest2(
                                  controller.totalEntranceStream(),
                                  controller.totalSlotStream(),
                                  (entranceData, slotData) => {
                                    "totalEntrance": entranceData,
                                    "totalSlot": slotData,
                                  },
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> totalEntrance =
                                        snapshot.data!["totalEntrance"];
                                    Map<String, dynamic> totalSlot =
                                        snapshot.data!["totalSlot"];

                                    int jumlahMasuk =
                                        totalEntrance["jumlahMasuk"];
                                    int jumlahSlot = totalSlot["jumlahSlot"];

                                    double percentage = jumlahSlot > 0
                                        ? jumlahMasuk / jumlahSlot
                                        : 0.0;

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.people,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Jumlah Pengunjung Masuk : ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes.parkingVisitor);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        getColorForPercentage(
                                                                percentage)
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "$jumlahMasuk / $jumlahSlot",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          getColorForPercentage(
                                                              percentage),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: percentage,
                                                          backgroundColor:
                                                              Colors.white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            getColorForPercentage(
                                                                    percentage)
                                                                .withOpacity(
                                                                    0.8),
                                                          ),
                                                          minHeight: 10,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "${(percentage * 100).toStringAsFixed(1)}%",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamUser(),
                                  builder: (context, snapUser) {
                                    if (snapUser.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    Map<String, dynamic> user =
                                        snapUser.data!.data()!;

                                    return SizedBox(
                                        child: QrImageView(
                                      data: user['uid'],
                                      version: QrVersions.auto,
                                    ));
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Card(
                      // Isi card Column 4
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Periksa kondisi untuk menentukan teksnya
                          const Text("Kontrol Parkir"),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () => Get.toNamed(Routes.parking),
                                  child: const Text("Lihat"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // Column 2
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: Card(
                          // Isi card Column 4
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Periksa kondisi untuk menentukan teksnya
                              const Text("Kontrol Kamera"),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (!controller
                                            .pythonScriptExecuted.value) {
                                          controller.runPythonScript();
                                        }
                                        Get.toNamed(Routes.camera);
                                      },
                                      child: const Text("Lihat"))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Column 3
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

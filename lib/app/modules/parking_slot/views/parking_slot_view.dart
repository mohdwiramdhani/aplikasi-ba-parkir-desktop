import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:dotted_border/dotted_border.dart';
import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';

import '../controllers/parking_slot_controller.dart';

class ParkingSlotView extends GetView<ParkingSlotController> {
  ParkingSlotView({super.key});

  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Parkir'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Get.toNamed(Routes.parkingSlotLayout, arguments: user),
            icon: const Icon(Icons.add_to_queue_rounded),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: rx.Rx.combineLatest2(
          controller.positionListStream(),
          controller.streamParking(),
          (positionData, parkingData) {
            // Di sini, Anda dapat mengakses data positionData dan parkingData
            // Sesuaikan dengan kebutuhan logika aplikasi Anda
            return {
              "positionData": positionData,
              "parkingData": parkingData,
            };
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Dapatkan data position dan user
            Map<int, Map<String, String>> positionData =
                snapshot.data!['positionData'];
            List<Map<String, dynamic>> parkingList =
                snapshot.data!['parkingData']['parkingList'];

            return ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<Map<String, dynamic>>(
                      stream: rx.Rx.combineLatest2(
                        controller.totalEntranceStream(),
                        controller.totalSlotStream(),
                        (entranceData, slotData) => {
                          "totalEntrance":
                              entranceData, // Sesuaikan dengan kunci yang benar
                          "totalSlot":
                              slotData, // Sesuaikan dengan kunci yang benar
                        },
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> totalEntrance =
                              snapshot.data!["totalEntrance"];
                          Map<String, dynamic> totalSlot =
                              snapshot.data!["totalSlot"];

                          int jumlahMasuk = totalEntrance["jumlahMasuk"];
                          int jumlahSlot = totalSlot["jumlahSlot"];

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            color: Colors.blue,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Jumlah Pengunjung Masuk : ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.parkingVisitor);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "$jumlahMasuk / $jumlahSlot",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 20, bottom: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // a
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Basement',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle floor 1 selection
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Lantai 1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle floor 2 selection
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Lantai 2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle floor 3 selection
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Lantai 3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle floor 4 selection
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Lantai 4',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          9,
                          (columnIndex) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                3,
                                (rowIndex) {
                                  int number = rowIndex * 9 + columnIndex + 1;

                                  // Periksa apakah nomor slot ada dalam data
                                  if (positionData.containsKey(number)) {
                                    String codeSlotText =
                                        positionData[number]!["codeSlot"]
                                            .toString();
                                    String status =
                                        positionData[number]!["status"]
                                            .toString();
                                    Color boxColor = (status == "on")
                                        ? const Color.fromARGB(80, 244, 67, 54)
                                        : const Color.fromARGB(80, 76, 175, 79);

                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String? codeSlot =
                                                positionData.containsKey(number)
                                                    ? positionData[number]![
                                                        "codeSlot"]
                                                    : "";
                                            String? statusSlot =
                                                positionData.containsKey(number)
                                                    ? positionData[number]![
                                                        "status"]
                                                    : "";
                                            String? platSlot = positionData
                                                    .containsKey(number)
                                                ? positionData[number]!["plat"]
                                                : "";
                                            String? dateOnSlot =
                                                positionData.containsKey(number)
                                                    ? positionData[number]![
                                                        "dateOn"]
                                                    : "";
                                            String? timeOnSlot =
                                                positionData.containsKey(number)
                                                    ? positionData[number]![
                                                        "timeOn"]
                                                    : "";
                                            return AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Informasi Slot'),
                                                  if (statusSlot == "on")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: const Text(
                                                        'Terisi',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  if (statusSlot == "off")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Tersedia',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Nomor Slot: $number'),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'Kode Slot: $codeSlot'),
                                                    const SizedBox(height: 10),
                                                    const Divider(),
                                                    const SizedBox(height: 10),
                                                    if (statusSlot == "on")
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Tanggal: $dateOnSlot'),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              'Jam: $timeOnSlot'),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          const Divider(),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              '$platSlot',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          if (parkingList.any(
                                                              (parking) =>
                                                                  parking[
                                                                      'plate'] ==
                                                                  platSlot))
                                                            Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      controller
                                                                          .messageC,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'Pesan',
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    String uid = parkingList.firstWhere((parking) =>
                                                                        parking[
                                                                            'plate'] ==
                                                                        platSlot)['uid'];

                                                                    // Mengirim uid dan plat ke metode sendMessage
                                                                    controller
                                                                        .sendMessage(
                                                                            uid);
                                                                  },
                                                                  child: const Text(
                                                                      'Kirim'),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog
                                                  },
                                                  child: const Text('Tutup'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    60, 0, 0, 0),
                                                width: 2.0,
                                              ),
                                              color: boxColor,
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                AnimatedOpacity(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  opacity: (status == "on")
                                                      ? 1.0
                                                      : 0.0,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/img/car3.png',
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      if (codeSlotText
                                                          .isNotEmpty)
                                                        const SizedBox(
                                                          width: 75,
                                                          height: 130,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  codeSlotText,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        color:
                                            const Color.fromARGB(40, 0, 0, 0),
                                        strokeWidth: 2.0,
                                        radius: const Radius.circular(9.0),
                                        dashPattern: const [10, 5],
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 75,
                                                  height: 160,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.5),
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/img/cctv.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "CCTV",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
    );
  }
}

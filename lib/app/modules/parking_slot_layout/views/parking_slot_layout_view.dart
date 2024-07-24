import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parking_slot_layout_controller.dart';

class ParkingSlotLayoutView extends GetView<ParkingSlotLayoutController> {
  ParkingSlotLayoutView({super.key});
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PETA PARKIR'),
          centerTitle: true,
        ),
        body: Container(
          padding:
              const EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
          child: Column(
            children: [
              const Text(
                "Pemetaan Slot Parkir",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Jarak antara tombol dan GridView
              StreamBuilder<List<int>>(
                stream: controller
                    .positionListStream(), // Gunakan stream yang telah Anda buat
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<int> positionList = snapshot.data!;

                    return Expanded(
                      child: ListView(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Tambahkan border radius di sini
                                ),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 9,
                                    crossAxisSpacing: 15.0,
                                    mainAxisSpacing: 15.0,
                                  ),
                                  itemCount: 27,
                                  itemBuilder: (context, index) {
                                    int number = index + 1;
                                    Color boxColor = Colors.white;
                                    String codeSlotText = "";

                                    final indexInList =
                                        positionList.indexOf(number);
                                    if (indexInList != -1) {
                                      codeSlotText =
                                          controller.codeList[indexInList];
                                      boxColor = Colors.blue.withOpacity(0.5);
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.parkingSlotLayoutDetail,
                                          arguments: number,
                                        );
                                      },
                                      child: Container(
                                        width:
                                            30, // Sesuaikan dengan lebar kotak yang diinginkan
                                        height:
                                            60, // Sesuaikan dengan tinggi kotak yang diinginkan
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                60, 0, 0, 0),
                                            width: 2.0,
                                          ),
                                          color: boxColor,
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Tambahkan border radius di sini
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (codeSlotText.isNotEmpty)
                                                Text(
                                                  codeSlotText,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (codeSlotText.isNotEmpty)
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              Text(
                                                number.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
              )
            ],
          ),
        ));
  }
}

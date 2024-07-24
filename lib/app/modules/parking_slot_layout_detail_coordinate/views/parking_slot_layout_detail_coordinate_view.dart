import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_ba_parkir_desktop/app/modules/parking_slot_layout_detail/controllers/parking_slot_layout_detail_controller.dart';

class ParkingSlotLayoutDetailCoordinateView extends StatefulWidget {
  final ParkingSlotLayoutDetailController controller;

  const ParkingSlotLayoutDetailCoordinateView(
      {super.key, required this.controller});

  @override
  _ParkingSlotLayoutDetailCoordinateViewState createState() =>
      _ParkingSlotLayoutDetailCoordinateViewState();
}

class _ParkingSlotLayoutDetailCoordinateViewState
    extends State<ParkingSlotLayoutDetailCoordinateView> {
  List<Offset?> points = List.filled(4, null);
  int currentArea = 0;

  bool get allPointsClicked {
    return points.every((point) => point != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Koordinat Slot Parkir'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          // Koordinat klik
                          Offset clickPoint = details.localPosition;

                          points[currentArea] = clickPoint;

                          currentArea = (currentArea + 1) % 4;
                          setState(() {});
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 800, // Atur lebar sesuai kebutuhan
                              height: 600, // Atur tinggi sesuai kebutuhan
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                              ),
                              child: Image.network(
                                'http://192.168.234.1/capture',
                                fit: BoxFit
                                    .fill, // Sesuaikan properti fit sesuai kebutuhan
                              ),
                            ),

                            // Menampilkan koordinat yang diklik
                            ...points.map((point) {
                              if (point != null) {
                                return Positioned(
                                  left:
                                      point.dx - 5, // Mengatur posisi titik (X)
                                  top:
                                      point.dy - 5, // Mengatur posisi titik (Y)
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                          .withOpacity(0.7), // Warna titik
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                            // Draw lines connecting the points
                            CustomPaint(
                              painter: MyPainter(points),
                            ),
                            Positioned(
                              top: 16.0,
                              right: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  for (int i = 0; i < points.length; i++)
                                    if (points[i] != null)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                                width: 2.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'X${i + 1}, Y${i + 1} = ${points[i]!.dx.toInt()}, ${points[i]!.dy.toInt()}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Simpan button aligned to the top-right corner
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: ElevatedButton(
                        onPressed: allPointsClicked
                            ? () {
                                Get.back(result: {
                                  'x1y1': points[0],
                                  'x2y2': points[1],
                                  'x3y3': points[2],
                                  'x4y4': points[3],
                                });
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors
                                    .grey; // Warna tombol saat disabled
                              }
                              return Colors.blue; // Warna tombol saat enabled
                            },
                          ),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Offset?> points;

  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length - 1; i += 2) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Menggambar garis tambahan yang menghubungkan titik 1 ke titik 4
    if (points[0] != null && points[3] != null) {
      canvas.drawLine(points[0]!, points[3]!, paint);
    }

    // Menggambar garis tambahan yang menghubungkan titik 2 ke titik 3
    if (points[1] != null && points[2] != null) {
      canvas.drawLine(points[1]!, points[2]!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

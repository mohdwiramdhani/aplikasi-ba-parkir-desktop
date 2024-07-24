import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_ba_parkir_desktop/app/modules/camera/controllers/camera_controller.dart';

class CameraView extends GetView<CameraController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KAMERA'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 800,
                height: 600,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue), // Border merah
                  borderRadius: BorderRadius.circular(10.0), // Border radius 10
                ),
                child: StreamBuilder(
                  stream: controller.imageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Uint8List bytes = snapshot.data as Uint8List;

                      return Image.memory(
                        bytes,
                        fit: BoxFit
                            .cover, // Agar gambar sesuai dengan ukuran container
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

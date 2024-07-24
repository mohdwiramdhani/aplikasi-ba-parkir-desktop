// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectionScreen extends StatefulWidget {
  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  late GoogleMapController mapController;

  // Posisi awal peta
  final LatLng initialPosition = const LatLng(-6.2088, 106.8456);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi di Peta'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 15.0,
        ),
        onTap: (position) {
          // Setelah pengguna menyentuh peta, kirim lokasi yang dipilih kembali
          Navigator.pop(context, LatLng(position.latitude, position.longitude));
        },
      ),
    );
  }
}

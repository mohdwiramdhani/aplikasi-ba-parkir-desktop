import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraController extends GetxController {
  late WebSocketChannel _channel;
  bool isWebSocketConnected = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  CameraController() {
    initWebSocket();
    startReceiving();
  }

  Future<void> runPythonScript() async {
    String currentUserUid = auth.currentUser!.uid;
    await Process.run(
      'python',
      ['python/flutter.py', currentUserUid],
    );
  }

  void initWebSocket() {
    _channel = IOWebSocketChannel.connect('ws://127.0.0.1:8888');
  }

  void closeWebSocket() {
    _channel.sink.close();
  }

  StreamController<Uint8List> _imageStreamController =
      StreamController<Uint8List>();

  Stream<Uint8List> get imageStream => _imageStreamController.stream;

  void startReceiving() {
    _channel.stream.listen((data) {
      Uint8List imgBytes = data;

      // Add Uint8List directly to the stream
      _imageStreamController.add(imgBytes);
    });
  }
}

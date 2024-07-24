import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:get/get.dart';
import 'package:skripsi_ba_parkir_desktop/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            // initialRoute: Routes.HOME,
            initialRoute: Routes.login,
            getPages: AppPages.routes,
          );
        }),
  );
}

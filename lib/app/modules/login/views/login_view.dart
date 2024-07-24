import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/bg/bg-login.jpg"),
                  fit: BoxFit.cover,
                ),
                color:
                    Colors.black.withOpacity(0.5), // Sesuaikan nilai opasitas
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "BA PARKIR",
                    style: TextStyle(
                        fontSize: 56,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Perancangan dan Implementasi Aplikasi Sistem Parkir Pintar Berbasis IoT Dengan Teknologi Artificial Intelligence",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/logo/logo.png", // Sesuaikan dengan path file gambar di folder assets
                        width:
                            450, // Sesuaikan dengan lebar gambar yang diinginkan
                        height:
                            350, // Sesuaikan dengan tinggi gambar yang diinginkan
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Bagian Kanan (Form Login)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailC,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      
                      prefixIcon: Icon(Icons.email), // Ikon Email
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TextField Password dengan ikon
                  Obx(
                    () => TextField(
                      obscureText: controller.isPasswordHidden.isTrue,
                      controller: controller.passwordC,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.isPasswordHidden.toggle();
                          },
                          icon: Icon(
                            controller.isPasswordHidden.isTrue
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            double.infinity, 50), // Sesuaikan dengan kebutuhan
                      ),
                      child: Text(
                        controller.isLoading.isFalse ? "LOGIN" : "LOADING",
                      ),
                    ),
                  ),

                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Divider(
                  //   thickness: 2,
                  //   color: Colors.grey.shade400,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     // Get.toNamed(Routes.forgotPassword);
                  //   },
                  //   child: const Text("Lupa Password?"),
                  // ),

                  // TextButton(
                  //   onPressed: () => Get.toNamed(Routes.REGISTER),
                  //   child: Text("Register User"),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePoint(String text) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 5, // Atur sesuai kebutuhan
          backgroundColor: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
              fontSize: 14, color: Color.fromARGB(226, 255, 255, 255)),
        ),
      ],
    );
  }
}

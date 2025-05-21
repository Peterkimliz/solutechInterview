import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/controllers/home_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => homeController.pages[homeController.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.grey,
              currentIndex: homeController.currentIndex.value,
              onTap: (value) {
                homeController.currentIndex.value = value;
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.stacked_bar_chart), label: "Dashboard"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event), label: "Visits"),
              ])),
    );
  }
}

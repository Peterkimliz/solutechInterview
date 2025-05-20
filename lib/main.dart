import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/app_bindings.dart';
import 'package:solutech/screens/home.dart';

import 'controllers/activities_controller.dart';
import 'controllers/customers_controller.dart';
import 'controllers/visits_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CustomersController customersController =
      Get.put<CustomersController>(CustomersController());
  final VisitsController visitsController =
      Get.put<VisitsController>(VisitsController());
  final ActivitiesController activitiesController =
      Get.put<ActivitiesController>(ActivitiesController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Solutech",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white
        )
      ),
      initialBinding: AppBindings(),
      home:  Home(),
    );
  }
}

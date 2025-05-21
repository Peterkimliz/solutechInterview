import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:solutech/app_bindings.dart';
import 'package:solutech/controllers/home_controller.dart';
import 'package:solutech/screens/home/home.dart';
import 'controllers/activities_controller.dart';
import 'controllers/customers_controller.dart';
import 'controllers/visits_controller.dart';
import 'models/activity.dart';
import 'models/customer.dart';
import 'models/visit.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VisitModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CustomersController customersController =
      Get.put<CustomersController>(CustomersController());
  final VisitsController visitsController =
      Get.put<VisitsController>(VisitsController());
  final ActivitiesController activitiesController = Get.put<ActivitiesController>(ActivitiesController());
  final HomeController homeController = Get.put<HomeController>(HomeController());

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

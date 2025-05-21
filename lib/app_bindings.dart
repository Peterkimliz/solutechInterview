import 'package:get/get.dart';
import 'package:solutech/controllers/activities_controller.dart';
import 'package:solutech/controllers/customers_controller.dart';
import 'package:solutech/controllers/home_controller.dart';
import 'package:solutech/controllers/visits_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomersController>(CustomersController(), permanent: true);
    Get.put<VisitsController>(VisitsController(), permanent: true);
    Get.put<ActivitiesController>(ActivitiesController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}

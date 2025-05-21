import 'package:get/get.dart';
import 'package:solutech/screens/statistics/statistics.dart';
import 'package:solutech/screens/visits/visit_lists.dart';

class HomeController extends GetxController {
  RxInt currentIndex = RxInt(0);

  List pages = [
    Dashboard(),
    VisitList(),

  ];
}
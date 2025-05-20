import 'dart:convert';

import 'package:get/get.dart';
import 'package:solutech/services/customers.dart';

import '../models/customer.dart';
import '../utils/functions.dart';

class CustomersController extends GetxController {
  RxList<Customer> customers = RxList([]);
  RxBool loadingCustomers = RxBool(false);

  fetchCustomers() async {
    try {
      loadingCustomers.value = true;
      var response = await CustomersApi.getCustomers();
      List data = response["data"];
      List<Customer> viModel = data.map((e) => Customer.fromJson(e)).toList();
      customers.assignAll(viModel);
      debugPrintMessage("The response is ${customers.map((e) => e).toList()}");
      loadingCustomers.value = false;
    } catch (e) {
      loadingCustomers.value = false;

      debugPrintMessage("Error Occurred is ${e}");
    }
  }

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }
}

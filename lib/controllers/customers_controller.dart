import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:solutech/services/customers.dart';

import '../models/customer.dart';
import '../models/visit.dart';
import '../utils/functions.dart';

class CustomersController extends GetxController {
  late Box<CustomerModel> localBox;
  late Stream<ConnectivityResult> connectivityStream;

  RxList<CustomerModel> customers = RxList([]);
  RxBool loadingCustomers = RxBool(false);

  fetchCustomers() async {
    try {
      customers.clear();
      loadingCustomers.value = true;
      bool isConnected = await isInternet();
      if (isConnected) {
        var response = await CustomersApi.getCustomers();
        List data = response["data"];
        List<CustomerModel> viModel =
            data.map((e) => CustomerModel.fromJson(e)).toList();
        customers.assignAll(viModel);
        await localBox.clear();
        for(CustomerModel customerModel in customers){
          await localBox.add(customerModel);
        }
      } else {
        List<CustomerModel> unsynced = localBox.values.toList();
        customers.assignAll(unsynced);
      }

      loadingCustomers.value = false;
    } catch (e) {
      loadingCustomers.value = false;

      debugPrintMessage("Error Occurred is ${e}");
    }
  }

  @override
  void onInit() async {
    localBox = await Hive.openBox<CustomerModel>('customers');
    connectivityStream = Connectivity().onConnectivityChanged;
    fetchCustomers();
    connectivityStream.listen((result) {
        fetchCustomers();
    });

    super.onInit();
  }
}

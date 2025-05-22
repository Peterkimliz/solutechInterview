import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:solutech/controllers/customers_controller.dart';
import 'package:solutech/models/activity.dart';
import 'package:solutech/services/visits.dart';
import 'package:solutech/utils/functions.dart';

import '../models/customer.dart';
import '../models/visit.dart';

class VisitsController extends GetxController {
  late Box<VisitModel> localBox;
  late Stream<ConnectivityResult> connectivityStream;
  RxList<VisitModel> visits = RxList([]);
  RxList<ActivityModel> selectedActivities = RxList([]);
  RxList<VisitModel> searchedList = RxList([]);
  RxBool loadingVisits = RxBool(false);
  Rxn<CustomerModel> selectedCustomer = Rxn(null);
  final formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final notesController = TextEditingController();
  Rxn<DateTime> visitDate = Rxn(DateTime.now());
  RxString status = RxString('Pending');
  TextEditingController filterVisits = TextEditingController();

  fetchVisits() async {
    try {
      visits.clear();
      loadingVisits.value = true;
      bool isConnected = await isInternet();
      if (isConnected) {
        var response = await VisitsApi.getVisits();
        List data = response["data"];
        debugPrintMessage("$data");
        List<VisitModel> viModel =
        data.map((e) => VisitModel.fromJson(e)).toList();
        visits.assignAll(viModel);
        await localBox.clear();
        for(VisitModel viModel in visits){
          await localBox.add(viModel);
        }
      } else {
        print("This is the si units");
        List<VisitModel> unsynced = localBox.values.toList();
        print("Kimani is the si units");
        visits.assignAll(unsynced);
      }




      loadingVisits.value = false;
    } catch (e) {
      loadingVisits.value = false;
      debugPrintMessage("Error Occurred is ${e}");
    }
  }

  void saveVisit({bool isEditting = false}) async {
    try {
      if (formKey.currentState!.validate()) {
        showDefaultGetDialog(
            message: "${isEditting ? "Updating" : "Saving"} Visit");
        VisitModel visitModel = VisitModel(
          customerId: selectedCustomer.value!.id,
          visitDate:
              DateTime.parse(DateFormat("yyyy-MM-dd").format(visitDate.value!))
                  .toIso8601String(),
          status: status.value,
          location: locationController.text,
          activitiesDone:
              selectedActivities.map((e) => e.id.toString()).toList(),
          notes: notesController.text,
        );
        debugPrintMessage("body to  api ${visitModel.toJson()}");
        bool isInternetConnected = await isInternet();
        if (isInternetConnected == true) {
          var response = await VisitsApi.saveVisit(
              body: visitModel.toJson(), isEditting: isEditting);
          debugPrintMessage("Testing api $response");
          Get.back();
          if (isEditting == false && response["status"] == 201) {
            Get.back();
            fetchVisits();
          }
        } else {
          saveVisitOffline(visitModel);
        }
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("error is $e");
    }
  }

  Future<void> saveVisitOffline(VisitModel visit) async {
    try {
      visit.isSynced = false;
      await localBox.add(visit);
      Get.back();
      clearInputs();
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Visit saved locally. Will sync when online.",
            style: TextStyle(color: Colors.white),
          )));
    } catch (e) {
      debugPrintMessage("Error Occured is $e");
    }
  }

  Future<void> syncOfflineVisits() async {
    final unsynced = localBox.values.where((v) => v.isSynced == false).toList();
    for (VisitModel visit in unsynced) {
      await VisitsApi.saveVisit(body: visit.toJson());
      visit.isSynced=true;
      await visit.save();
    }
    fetchVisits();
  }

  @override
  void onInit() async {
    localBox = await Hive.openBox<VisitModel>('visits');
    connectivityStream = Connectivity().onConnectivityChanged;
    fetchVisits();
    connectivityStream.listen((result) {
      fetchVisits();

      if (result != ConnectivityResult.none) {
        syncOfflineVisits();
      }
    });
    super.onInit();
  }

  void filterVisit(String value) {
    List<VisitModel> search = visits
        .where((v) => v.status!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    searchedList.assignAll(search);
  }

  void clearInputs() {
    selectedCustomer.value = null;
    visitDate.value = DateTime.now();
    status.value = "Pending";
    locationController.clear();
    notesController.clear();
    selectedActivities.clear();
  }

  assignFields({VisitModel? visit}) {
    CustomersController customersController = Get.find<CustomersController>();
    print("object");
    locationController.text = visit!.location!;
    notesController.text = visit.notes!;
    // visitDate.value = visit.visitDate;
    status.value = visit.status!.capitalize!;

    int index = customersController.customers
        .indexWhere((e) => e.id == visit.customerId);
    if (index != -1) {
      selectedCustomer.value = customersController.customers[index];
    }
  }
}

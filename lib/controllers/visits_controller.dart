import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solutech/controllers/customers_controller.dart';
import 'package:solutech/services/visits.dart';
import 'package:solutech/utils/functions.dart';

import '../models/customer.dart';
import '../models/visit.dart';

class VisitsController extends GetxController {
  RxList<VisitModel> visits = RxList([]);
  RxBool loadingVisits = RxBool(false);
  RxBool isSearching = RxBool(false);
  Rxn<Customer> selectedCustomer = Rxn(null);

  final formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final notesController = TextEditingController();
  Rxn<DateTime> visitDate = Rxn(DateTime.now());
  RxString status = RxString('Pending');
  RxList<int> selectedActivities = RxList([]);

  TextEditingController filterVisits = TextEditingController();

  fetchVisits() async {
    try {
      loadingVisits.value = true;
      var response = await VisitsApi.getVisits();
      debugPrintMessage("hehe${response["data"]}");
      List data = response["data"];

      List<VisitModel> viModel =
          data.map((e) => VisitModel.fromJson(e)).toList();
      visits.assignAll(viModel);
      debugPrintMessage("The response is ${visits.map((e) => e).toList()}");
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
        Map<String, dynamic> body = {
          "customer_id": selectedCustomer.value!.id,
          "visit_date":
              DateTime.parse(DateFormat("yyyy-MM-dd").format(visitDate.value!))
                  .toIso8601String(),
          "status": status.value,
          "location": locationController.text,
          "notes": notesController.text,
        };
        debugPrintMessage("body to  api ${body}");
        var response = await VisitsApi.saveVisit(body: body,isEditting:isEditting);
        debugPrintMessage("Testing api ${response}");
        Get.back();
        if (isEditting && response["status"] == 201) {
          Get.back();
          clearInputs();
          fetchVisits();
        }
        debugPrintMessage("The response is ${response}");
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("error is $e");
    }
  }

  void clearInputs() {
    selectedCustomer.value = null;
    visitDate.value = DateTime.now();
    status.value = "Pending";
    locationController.clear();
    notesController.clear();
  }

  assignFields({VisitModel? visit}) {
    CustomersController customersController = Get.find<CustomersController>();
    print("object");
    locationController.text = visit!.location!;
    notesController.text = visit.notes!;
    visitDate.value = visit.visitDate;
    status.value = visit.status!.capitalize!;

    int index = customersController.customers
        .indexWhere((e) => e.id == visit.customerId);
    if (index != -1) {
      selectedCustomer.value = customersController.customers[index];
    }
  }
}

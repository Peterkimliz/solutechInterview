import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/controllers/customers_controller.dart';
import 'package:solutech/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:solutech/models/visit.dart';

import '../controllers/visits_controller.dart';
import '../widgets/inputs_deco.dart';

class AddVisitScreen extends StatelessWidget {
  final VisitModel? visit;
  bool isEditting;

  AddVisitScreen({super.key, this.visit, this.isEditting = false}) {
    if (customersController.customers.isEmpty) {
      customersController.fetchCustomers();
    }
    if (isEditting == true) {
      visitController.assignFields(visit: visit);
    }
  }

  final CustomersController customersController =
      Get.find<CustomersController>();
  final VisitsController visitController = Get.find<VisitsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${isEditting ? "Edit" : "Add"} Visit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: visitController.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Customer"),
                const SizedBox(height: 5),
                Obx(() => DropdownSearch<Customer>(
                      selectedItem: visitController.selectedCustomer.value,
                      enabled: customersController.customers.isNotEmpty,
                      items: (filter, infiniteScrollProps) =>
                          customersController.customers,
                      compareFn: (item, selectedItem) =>
                          item.id == selectedItem.id,
                      validator: (value) {
                        if (value == null) {
                          return "Please select customer";
                        }
                        return null;
                      },
                      itemAsString: (far) {
                        return far.name!.toString().capitalize!;
                      },
                      dropdownBuilder: (context, item) {
                        return Text(item?.name.toString().capitalize! ?? "");
                      },
                      // Customize this based on your object properties
                      popupProps: PopupProps.menu(
                        onDismissed: () {
                          // Optional: Handle dismiss
                        },
                        showSearchBox: true,
                        menuProps: const MenuProps(
                          elevation: 16,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      onChanged: (value) {
                        visitController.selectedCustomer.value = value!;
                      },
                    )),
                const SizedBox(height: 16),
                TextFormField(
                  controller: visitController.locationController,
                  decoration: inputDecoration(hint: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Obx(() => ListTile(
                        title: const Text('Visit Date'),
                        subtitle: Text(
                            '${DateFormat("dd MMM yyyy").format(visitController.visitDate.value!)}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            visitController.visitDate.value = date;
                          }
                        },
                      )),
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                      value: visitController.status.value,
                      items: ['Pending', 'Completed', 'Cancelled']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        visitController.status.value = value!;
                      },
                      decoration: inputDecoration(hint: 'Status'),
                    )),
                const SizedBox(height: 16),
                TextFormField(
                    controller: visitController.notesController,
                    decoration: inputDecoration(hint: 'Notes'),
                    maxLines: 6,
                    minLines: 3),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.deepPurple)),
                    onPressed: () {
                      visitController.saveVisit(isEditting: isEditting);
                    },
                    child: Text(
                      isEditting ? "Update Visit" : 'Save Visit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

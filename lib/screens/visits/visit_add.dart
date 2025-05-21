import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/controllers/customers_controller.dart';
import 'package:solutech/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:solutech/models/visit.dart';

import '../../controllers/visits_controller.dart';
import '../../widgets/inputs_deco.dart';
import '../activities/activities_page.dart';

class AddVisitScreen extends StatelessWidget {
  final VisitModel? visit;
  final bool isEditting;

  AddVisitScreen({super.key, this.visit, this.isEditting = false}) {
    visitController.clearInputs();
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
      appBar: AppBar(
        title: Text('${isEditting ? "Edit" : "Add"} Visit'),

      ),
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
                Obx(() => DropdownSearch<CustomerModel>(
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
                Text("Activities"),
                SizedBox(height: 1),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(()=>Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: ListView(
                          children: [
                            Wrap(
                               children: visitController.selectedActivities
                                    .map((e) => Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: (){
                                          visitController.selectedActivities.removeWhere((f) => f.id == e.id!);
                                          visitController.selectedActivities.refresh();
                                        },
                                        child: Chip(label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e.description!,style: TextStyle(fontSize: 10),),

                                            Icon(Icons.clear,size: 12,color: Colors.red,)
                                          ],
                                        )),
                                      ),
                                    ))
                                    .toList()
                            )
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => ActivitiesPage());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple, shape: BoxShape.circle),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
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

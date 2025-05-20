import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:solutech/controllers/visits_controller.dart';
import 'package:solutech/models/visit.dart';
import 'package:solutech/screens/visit_add.dart';

class Home extends StatelessWidget {
  Home({super.key}) {
    visitsController.fetchVisits();
  }

  VisitsController visitsController = Get.find<VisitsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        titleSpacing: 0,
        leading: Obx(() => visitsController.isSearching.value == true
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  visitsController.isSearching.value = false;
                })
            : const Icon(null)),
        title: Obx(() => visitsController.isSearching.value
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: TextFormField(
                  controller: visitsController.filterVisits,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    hintText: "Search...",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            : const Text('Visits')),
        actions: [
          Obx(() => visitsController.isSearching.value
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    visitsController.isSearching.value = true;
                  })),
        ],
      ),
      body: RefreshIndicator(child: Obx(() {
        return visitsController.loadingVisits.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: visitsController.visits.length,
                  itemBuilder: (context, index) {
                    VisitModel visit = visitsController.visits.elementAt(index);
                    return ListTile(
                      onTap: () {
                        Get.to(() => AddVisitScreen(
                          visit:visit,
                          isEditting:true
                        ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(visit.location!),
                                  Text(DateFormat("yyyy-MM-dd").format(visit.visitDate!)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [],
                                  )
                                ],
                              ),
                              Chip(
                                  backgroundColor:
                                      visit.status!.toLowerCase() == "completed"
                                          ? Colors.green
                                          : visit.status!.toLowerCase() ==
                                                  "cancelled"
                                              ? Colors.red
                                              : Colors.orange,
                                  label: Text(
                                    visit.status!,
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
              );
      }), onRefresh: () async {
        visitsController.fetchVisits();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddVisitScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

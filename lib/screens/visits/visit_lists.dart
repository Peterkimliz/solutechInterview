import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:solutech/controllers/visits_controller.dart';
import 'package:solutech/models/visit.dart';
import 'package:solutech/screens/visits/visit_add.dart';

class VisitList extends StatelessWidget {
  VisitList({super.key}) {
    visitsController.fetchVisits();
  }

  final VisitsController visitsController = Get.find<VisitsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        titleSpacing: 0,
        title: const Text('Visits'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              if (value == 0) {
                visitsController.searchedList.clear();
                visitsController.searchedList.refresh();
              }
              if (value == 1) {
                visitsController.filterVisit("completed");
              }
              if (value == 2) {
                visitsController.filterVisit("pending");
              }
              if (value == 3) {
                visitsController.filterVisit("cancelled");
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text("All"),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text("Completed"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Pending"),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("Cancelled"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Obx(() {
        return visitsController.loadingVisits.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: visitsController.searchedList.isNotEmpty
                    ? visitsController.searchedList.length
                    : visitsController.visits.length,
                itemBuilder: (context, index) {
                  VisitModel visit = visitsController.searchedList.isNotEmpty
                      ? visitsController.searchedList.elementAt(index)
                      : visitsController.visits.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Get.to(
                          () => AddVisitScreen(visit: visit, isEditting: true));
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
                                Text(DateFormat("yyyy-MM-dd")
                                    .format(DateTime.parse(visit.visitDate!))),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [],
                                )
                              ],
                            ),
                            Chip(
                                backgroundColor: visit.status!.toLowerCase() ==
                                        "completed"
                                    ? Colors.green
                                    : visit.status!.toLowerCase() == "cancelled"
                                        ? Colors.red
                                        : Colors.orange,
                                label: Text(
                                  visit.status!,
                                  style: const TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              );
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

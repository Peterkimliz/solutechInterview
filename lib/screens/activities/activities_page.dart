import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/controllers/activities_controller.dart';
import 'package:solutech/controllers/visits_controller.dart';
import 'package:solutech/models/activity.dart';

class ActivitiesPage extends StatelessWidget {
  ActivitiesPage({super.key}){
    if(activitiesController.activities.isEmpty){
      activitiesController.fetchActivities();
    }
  }

  ActivitiesController activitiesController = Get.find<ActivitiesController>();
  VisitsController visitsController = Get.find<VisitsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        actions: [
          Obx(() => visitsController.selectedActivities.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text("Done",style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ))
        ],
      ),
      body: Obx(() => activitiesController.loadingActivities.value
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: activitiesController.activities.length,
              itemBuilder: (BuildContext context, int index) {
                ActivityModel activityModel =
                    activitiesController.activities.elementAt(index);
                return ListTile(
                  onTap: () {
                    if (getIndex(activityModel.id!)) {
                      visitsController.selectedActivities
                          .removeWhere((e) => e.id == activityModel.id!);
                      visitsController.selectedActivities.refresh();
                    } else {
                      visitsController.selectedActivities.add(activityModel);
                      visitsController.selectedActivities.refresh();
                    }
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activityModel.description!.toString()),
                          Obx(() => getIndex(activityModel.id!)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.add,
                                  color: Colors.purple,
                                ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            )),
    );
  }

  bool getIndex(int id) {
    return visitsController.selectedActivities.indexWhere((e) => e.id == id) ==
            -1
        ? false
        : true;
  }
}

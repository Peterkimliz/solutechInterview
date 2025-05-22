import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:solutech/models/activity.dart';
import 'package:solutech/services/activities.dart';
import 'package:solutech/services/visits.dart';
import 'package:solutech/utils/functions.dart';

class ActivitiesController extends GetxController {
  late Box<ActivityModel> localBox;
  late Stream<ConnectivityResult> connectivityStream;

  RxList<ActivityModel> activities = RxList([]);
  RxBool loadingActivities = RxBool(false);

  fetchActivities() async {
    try {
      loadingActivities.value = true;
      bool isConnected = await isInternet();
      if (isConnected) {
        var response = await ActivitiesApi.getActivities();
        List data = response["data"];
        List<ActivityModel> viModel =
            data.map((e) => ActivityModel.fromJson(e)).toList();
        activities.assignAll(viModel);
         await localBox.clear();

        for (ActivityModel activ in activities) {
          await localBox.add(activ);
        }
      } else {
        List<ActivityModel> unsynced = localBox.values.toList();
        activities.assignAll(unsynced);
      }

      loadingActivities.value = false;
    } catch (e) {
      loadingActivities.value = false;
      debugPrintMessage("Error Occurred is ${e}");
    }
  }

  @override
  void onInit() async {
    localBox = await Hive.openBox<ActivityModel>('activities');
    connectivityStream = Connectivity().onConnectivityChanged;
    fetchActivities();
    connectivityStream.listen((result) {
      fetchActivities();
    });

    super.onInit();
  }

  getActivities(List<String> activitiesDone) {
    List<ActivityModel> filteredActivities = activities
        .where((activity) => activitiesDone.contains(activity.id.toString()))
        .toList();

    return Wrap(
        children: filteredActivities
            .map((e) => Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Chip(
                    padding: EdgeInsets.zero,
                      label: Text(
                    e.description!,
                    style: const TextStyle(fontSize: 10),
                  )),
                ))
            .toList());
  }
}

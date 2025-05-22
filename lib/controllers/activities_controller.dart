import 'package:connectivity_plus/connectivity_plus.dart';
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
}

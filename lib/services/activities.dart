import 'dart:convert';

import 'package:solutech/services/client.dart';
import 'package:solutech/services/endpoints.dart';

class ActivitiesApi {
  static getActivities() async {
    var response = await DbBase.databaseRequest(activities, DbBase.getRequest);
    return response;
  }
}

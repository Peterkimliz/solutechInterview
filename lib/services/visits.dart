import 'dart:convert';

import 'package:solutech/services/client.dart';
import 'package:solutech/services/endpoints.dart';

class VisitsApi {
  static getVisits() async {
    var response = await DbBase.databaseRequest(visits, DbBase.getRequest);
    return response;
  }

  static saveVisit(
      {required Map<String, dynamic> body, bool isEditting = false}) async {
    var response = await DbBase.databaseRequest(
        visits, isEditting ? DbBase.patchRequest : DbBase.postRequest,
        body: body);

    return response;
  }
}

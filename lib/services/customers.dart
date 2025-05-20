import 'dart:convert';

import 'package:solutech/services/client.dart';
import 'package:solutech/services/endpoints.dart';
import 'package:solutech/utils/functions.dart';

class CustomersApi {
  static getCustomers() async {
    var response = await DbBase.databaseRequest(customers, DbBase.getRequest);
    return response;
  }
}

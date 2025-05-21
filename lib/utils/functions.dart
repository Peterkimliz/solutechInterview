import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

debugPrintMessage(String message){
  if (kDebugMode) {
    print(message);
  }
}


showDefaultGetDialog({required String message, bool disMissable = false}) {

  return Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(

        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: disMissable,
  );
}

Future<bool> _pingGoogle() async {
  try {
    final conn = HttpClient();
    final request = await conn
        .getUrl(Uri.parse("https://www.google.com/generate_204"))
        .timeout(const Duration(seconds: 1));
    final response = await request.close().timeout(const Duration(seconds: 1));
    print("Status Code is ${response.statusCode}");
    return response.statusCode == 204;
  } catch (_) {
    return false;
  }
}

Future<bool> isInternet() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());

  debugPrintMessage("Connection result is $connectivityResult");
  if (connectivityResult == ConnectivityResult.mobile) {
    final isConnected = await _pingGoogle()
        .timeout(const Duration(seconds: 2), onTimeout: () => false);
    return isConnected;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    final isConnected = await _pingGoogle()
        .timeout(const Duration(seconds: 2), onTimeout: () => false);
    return isConnected;
  } else {
    debugPrintMessage(
        "Neither mobile data or WIFI detected, not internet connection found.");
    return false;
  }
}

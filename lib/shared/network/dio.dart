import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mf_app/models/usermodel.dart';

class diohelp {
  static Dio? mydio;

  static void init() async {
    mydio = await Dio(
      BaseOptions(
        baseUrl: "https://fcm.googleapis.com/fcm/send",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postmessegenotficarion(
      token, messege, name, mypic, myuid) {
    mydio!.options.headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAAAe7xJNg:APA91bEZFC1TJwxcmBCWfhLyDZDqjpPR1cZcikar1-1_UVNGN0pJR-RV6kDuH7_jAnZpQg_p0vtSn6tnTkvFB66JLLxSOGhnO2Wd1SUZddVk81isl8NbKp6qJYFDx-5w9wBz5IYvMj8k"
    };
    return mydio!.post("", data: {
      "notification": {"body": "$messege", "title": "$name"},
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "status": "done",
        "screen": "screenA",
        "name": name,
        "pic": mypic,
        "uid": myuid,
      },
      "to": "/topics/$token"
    });
  }
}

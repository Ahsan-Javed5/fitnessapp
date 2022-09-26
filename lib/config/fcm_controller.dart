import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:get/get.dart';

class FCMController extends BaseController {
  updateFCM(String token) async {
    MyHive.setFcm(token);
    await postReq('api/user/update/fcm', {'fcm_token': token},
        (p0) => MainGroup.fromJson(p0));
  }

  sendPushNotification(String to, String title, String body, Map data) async {
    if (to.isEmpty || title.isEmpty || body.isEmpty) return;

    Map<String, dynamic> requestBody = {
      'to': to,
      'collapse_key': 'type_a',
      'notification': {'title': title, 'body': body, 'sound': 'default'},
      'data': data
    };

    Map<String, String> headers = {
      'Authorization':
          'key=AAAAUhfwUtw:APA91bFB0FB29ibm9K5oDl-VFnrVxiUrA3z5G6yhLA5xt0d8fhv-dBqRXte7SgKeoyHEeY3Zv7rLyDGk-c4VxYl4SD-M0o6cT_v7SlwUcKXsEpS6IvjeYJtLycC6z6Rqf2i1qsnMjhiA',
      'Content-Type': 'application/json'
    };

    await GetConnect().post(
      'https://fcm.googleapis.com/fcm/send',
      requestBody,
      headers: headers,
    );
  }
}

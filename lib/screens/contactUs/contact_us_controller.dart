import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:get/get.dart';

class ContactUsController extends BaseController {
  BaseResponse? response;
  final countries = [];

  sendContactUsRequest(Map body) async {
    final result = await postReq(
        'api/user/contact', body, (json) => MainGroup.fromJson(json));

    if (!result.error) {
      Future.delayed(1.seconds, () => Get.back());
    }
  }

  void getAllCountries() async {
    await Future.delayed(1.milliseconds, () async {
      final result =
          await getReq(getCountriesEndPoint, (json) => Country.fromJson(json));
      if (result.data != null) countries.addAll(result.data ?? []);
      update([getCountriesEndPoint]);
    });
  }
}

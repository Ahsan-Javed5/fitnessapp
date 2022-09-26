import 'dart:developer';

import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/currency_model.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class CoachProfileController extends BaseController {
  final String _reportVideoEndPoint = 'api/user/add_query';

  bool showSubscribedUI = false;
  bool isGuest = false;
  User? coachData;
  var currencyModel = CurrencyModel().obs;

  @override
  void onInit() {
    super.onInit();

    if (Utils.isSubscribedUser() || Utils.isSubscribedCoach()) {
      showSubscribedUI = true;
    }

    if (MyHive.getUserType() == UserType.guest ||
        MyHive.getUserType() == UserType.noUser) {
      isGuest = true;
    }
  }

  reportVideo(String query, String videoId) async {
    Map<String, dynamic> body = {};
    body['query'] = query;
    body['video_id'] = videoId;
    final response = await patchReq(_reportVideoEndPoint, body, (p0) => null,
        singleObjectData: false);
    if (!response.error) {
      await Future.delayed(1.milliseconds, () => Get.back());
      showSnackBar('alert'.tr, response.message);
    }
  }

  bool isAllowPrivateChat() {
    bool isAllowChat = true;
    if (coachData != null && coachData!.allowPrivateChat != null) {
      isAllowChat = coachData!.allowPrivateChat!;
    }
    return isAllowChat;
  }

  ///In this fun we will get currency rates again USD via API
  ///Then convert local currency rate again USD price
  ///link of API website is https://freecurrencyapi.net/
  Future<CurrencyModel?> getCurrencyRates() async {
    log('going to load currency rates');

    String? myCountry = MyHive.getUser()?.country?.name;
    if (myCountry == null || myCountry.isEmpty) {
      log('user country not found!');
      return null;
    }

    String myCurrency = Utils.getCurrencyCodeFromCountry(myCountry);
    if (myCurrency.isEmpty) {
      myCurrency = 'USD';
    }

    ///replace API TOKEN with new one if requests quota reached
    //const String apiToken = '049ae800-4222-11ec-b727-eba1f9f85d7b';
    const String apiToken = 'bac065d0-8825-11ec-abfb-5f8ddf965203';

    ///50000 requests per month free
    const String _currencyRatesEndPoint =
        'https://freecurrencyapi.net/api/v2/latest';

    Map<String, dynamic> query = {};
    query['apikey'] = apiToken;

    try {
      dynamic response = await insecureRepository.get(
        _currencyRatesEndPoint,
        queryParameters: query,
      );

      if (response != null &&
          response.data != null &&
          response.statusCode != 401) {
        var data = response.data['data'];
        var rate = data[myCurrency];
        log('$myCurrency rate against USD is $rate');
        var currencyModel = CurrencyModel();
        currencyModel.name = myCurrency;
        currencyModel.rate = rate;
        return currencyModel;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void getCurrency() {
    final country = MyHive.getUser()?.country?.name ?? '';

    if (Utils.currencyModel != null &&
        (Utils.currencyModel!.name ==
            Utils.getCurrencyCodeFromCountry(country))) {
      currencyModel.value = Utils.currencyModel!;
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () async {
     // var _currencyModel = await getCurrencyRates();
     // if (_currencyModel != null) {
      //  Utils.currencyModel = _currencyModel;
       // currencyModel.value = _currencyModel;
     // }
    });
  }

  String getLocalRate(int totalUsd, CurrencyModel? currencyModel) {
    String completeString = '';

    if (currencyModel != null && currencyModel.name != null && totalUsd != 0) {
      var currencyAmount = currencyModel.rate;
      if (currencyAmount != null) {
        var totalAmount = (totalUsd * currencyAmount).round();
        completeString = ' ≈ $totalAmount ${currencyModel.name ?? ''}';
      }
    }
    return completeString;
  }
}

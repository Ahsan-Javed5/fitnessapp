import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';

class MFController extends BaseController {
  final paymentMethods = <PaymentMethods>[].obs;
  final paymentResponse = ''.obs;
  int selectedPaymentMethodId = 0;
  User? userData;

  @override
  void onInit() {
    MFSDK.init(MyHive.newLiveAPIKeyMFQTR, MFCountry.QATAR, MFEnvironment.LIVE);
    //MFSDK.init(MyHive.liveAPIKeyMF, MFCountry.QATAR, MFEnvironment.LIVE);
    MFSDK.setUpAppBar(
      title: 'Fit & More Payment',
      titleColor: Colors.white,
      backgroundColor: ColorConstants.appBlue,
      isShowAppBar: true,
    );
    super.onInit();
  }

  initiatePayment() async {
    paymentMethods.clear();
    Future.delayed(100.milliseconds, () {
      paymentResponse.value = 'Fetching payment methods...';
      final totalAmount = userData!.monthlySubscriptionPrice!.toDouble();
      const currencyISO = MFCurrencyISO.UNITED_STATE_USD;
      var request = MFInitiatePaymentRequest(
        totalAmount,
        currencyISO,
      );
      MFSDK.initiatePayment(
          request, Utils.isRTL() ? MFAPILanguage.AR : MFAPILanguage.EN,
          (MFResult<MFInitiatePaymentResponse> result) {
        if (result.isSuccess()) {
          if (result.response!.paymentMethods!.isNotEmpty) {
            for (PaymentMethods m in result.response!.paymentMethods!) {
              final name = m.paymentMethodEn!.toLowerCase();
              // if (name == 'visa/master' ||
              //     name == 'knet' ||
              //     name.contains('qatar debit cards') ||
              //     name.contains('qatar debit card') ||
              //     name.contains('naps'))
              paymentMethods.add(m);
            }
            selectedPaymentMethodId = paymentMethods[0].paymentMethodId ?? 0;
          }
        } else {
          Utils.showSnack('Payment Failed', result.error!.message.toString(),
              isError: true);
          paymentResponse.value = result.error!.message.toString();
        }
      });
    });
  }

  executePayment(BuildContext context) async {
    // The value 1 is the paymentMethodId of KNET payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    // int paymentMethod = 2;

    var request = MFExecutePaymentRequest(selectedPaymentMethodId,
        userData!.monthlySubscriptionPrice!.toDouble());

    /// 1-userID-coachID-TodayDate
    ///
    /// As a unique reference I’d
    ///
    /// 1 is static
    /// UserID: unique user ID
    /// CoachID: unique coach ID
    /// TodayDate: date of transaction
    request.customerReference =
        '1-${MyHive.getUser()?.id}-${userData?.id.toString()}-${DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now())}';

    request.displayCurrencyIso = 'USD';
    MFSDK.executePayment(context, request, MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) async {
      await Future.delayed(20.milliseconds, () => setLoading(false));
      if (result.isSuccess()) {
        Get.back();
        Utils.showSnack('Payment Success', 'Your payment is done successfully');
        _addSubscription(result);
      } else {
        Utils.showSnack('Payment Failed', result.error!.message.toString(),
            isError: true);
      }
    });
  }

  updateSelectedMethod(int v) {
    selectedPaymentMethodId = v;
    update(['mfBuilder']);
  }

  void _addSubscription(MFResult<MFPaymentStatusResponse> result) {
    //var userID = MyHive.getUser()?.id;
    var body = <String, dynamic>{};
    body['invoice_id'] = result.response?.invoiceId ?? '';
    body['amount_paid'] = userData?.monthlySubscriptionPrice.toString();
    body['user_id'] = MyHive.getAuthToken();
    body['coach_id'] = userData?.id.toString();

    SubscriptionController subsController = Get.find();
    subsController.addSubs(body);
  }
}

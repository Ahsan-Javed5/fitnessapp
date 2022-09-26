import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/dialogs/subscription/mf_controller.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodsDialog extends StatelessWidget {
  final User userData;

  const PaymentMethodsDialog({Key? key, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MFController());
    controller.initiatePayment();
    controller.userData = userData;

    return Scaffold(
      backgroundColor: ColorConstants.buttonGradientStartColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
            padding:
                EdgeInsets.only(bottom: Spaces.normY(4), top: Spaces.normY(1)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spaces.normX(2)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                /// Cross button

                /// Title
                Spaces.y2,
                Text(
                  'select_payment_method'.tr,
                  style: TextStyles.subHeadingSemiBold.copyWith(
                    fontSize: Spaces.normSP(16),
                    fontFamily: FontConstants.montserratExtraBold,
                  ),
                ),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: Spaces.normY(40),
                    child: controller.paymentMethods.isEmpty
                        ? EmptyView(
                            customMessage: controller.paymentResponse.value,
                          )
                        : GetBuilder<MFController>(
                            id: 'mfBuilder',
                            builder: (controller) => ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.paymentMethods.length,
                              itemBuilder: (context, index) {
                                final item = controller.paymentMethods[index];

                                return GestureDetector(
                                  onTap: () {
                                    controller.updateSelectedMethod(
                                        item.paymentMethodId!);
                                  },
                                  child: RadioListTile(
                                      value: item.paymentMethodId as int,
                                      groupValue:
                                          controller.selectedPaymentMethodId,
                                      title: Text(
                                        Utils.isRTL()
                                            ? item.paymentMethodAr!
                                            : item.paymentMethodEn!,
                                        style: TextStyles.normalBlackBodyText,
                                      ),
                                      dense: true,
                                      secondary: SizedBox(
                                        height: Spaces.normY(3),
                                        child: CustomNetworkImage(
                                          imageUrl: item.imageUrl,
                                          useDefaultBaseUrl: false,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      onChanged: (v) {
                                        controller
                                            .updateSelectedMethod(v as int);
                                      }),
                                );
                              },
                            ),
                          ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: Text('cancel'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(10),
                              vertical: Spaces.normY(Utils.isRTL() ? 1.5 : 2),
                            ),
                          ),
                        ),
                      ),
                      Spaces.x3,
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'continue'.tr,
                          onPressed: () async {
                            await controller.executePayment(context);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/dialogs/subscription/payment_methods_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SubscribeDialog extends StatelessWidget {
  final VoidCallback subscribeListener;
  final VoidCallback cancelListener;
  final User userData;

  const SubscribeDialog(
      {Key? key,
      required this.subscribeListener,
      required this.cancelListener,
      required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                  ),
                ),

                ClipOval(
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/svgs/ic_dollar_sign.svg',
                      fit: BoxFit.scaleDown,
                      color: ColorConstants.appBlue,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Spaces.normY(3.0),
                        horizontal: Spaces.normY(3)),
                    color: ColorConstants.veryLightBlue,
                  ),
                ),

                /// Title
                Spaces.y2,
                Text(
                  'subscribe'.tr,
                  style: TextStyles.subHeadingSemiBold.copyWith(
                    fontSize: Spaces.normSP(16),
                    fontFamily: FontConstants.montserratExtraBold,
                  ),
                ),

                Spaces.y2,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(3)),
                  child: Text(
                    'subscribe_desc'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyles.normalBlackBodyText.copyWith(
                      fontSize: Spaces.normSP(10),
                      fontFamily: FontConstants.montserratRegular,
                    ),
                  ),
                ),

                Spaces.y3,

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: cancelListener,
                          child: Text('cancel'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spaces.normX(10),
                              vertical: Spaces.normY(2),
                            ),
                          ),
                        ),
                      ),
                      Spaces.x3,
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'subscribe'.tr,
                          onPressed: () async {
                            Get.back();
                            showDialog(
                                context: context,
                                builder: (context) => PaymentMethodsDialog(
                                      userData: userData,
                                    ),
                                useSafeArea: false);
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

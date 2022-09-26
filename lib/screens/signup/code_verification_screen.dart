import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/actionBars/back_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../auth_controller.dart';

class CodeVerificationScreen extends StatelessWidget {
  CodeVerificationScreen({Key? key}) : super(key: key);
  final _smsController = TextEditingController();
  final _emailController = TextEditingController();

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.y4,
              const BackAndRightActionBar(),

              Spaces.y3,

              /// Main title
              Text(
                'verification'.tr,
                style: Get.textTheme.headline1,
              ),
              // Spaces.y1_0,
              // Text(
              //   'verification_desc'.tr +
              //       controller.formKey.currentState!.value['phone_number'],
              // ),
              //
              // /// OTP label
              // Spaces.y4,
              // CustomLabelField(labelText: 'code'.tr),
              // PinCodeTextField(
              //   length: 6,
              //   obscureText: false,
              //   keyboardType: TextInputType.number,
              //   textStyle: TextStyles.normalBlackBodyText.copyWith(
              //       fontSize: Spaces.normSP(14.5),
              //       fontFamily: FontConstants.montserratRegular),
              //   animationType: AnimationType.scale,
              //   pinTheme: PinTheme(
              //     shape: PinCodeFieldShape.underline,
              //     activeFillColor: Colors.transparent,
              //     selectedFillColor: Colors.transparent,
              //     selectedColor: ColorConstants.appBlack,
              //     disabledColor: Colors.transparent,
              //     inactiveColor: ColorConstants.appBlack,
              //     inactiveFillColor: Colors.transparent,
              //     errorBorderColor: ColorConstants.redButtonBackground,
              //     activeColor: ColorConstants.appBlack,
              //     borderWidth: Spaces.normX(0.3),
              //     fieldWidth: Spaces.normX(13),
              //   ),
              //   animationDuration: const Duration(milliseconds: 300),
              //   backgroundColor: Colors.transparent,
              //   enableActiveFill: true,
              //   controller: _smsController,
              //   onCompleted: (v) {},
              //   onChanged: (value) {},
              //   beforeTextPaste: (text) {
              //     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //     //but you can show anything you want here, like your pop up saying wrong paste format or etc
              //     return true;
              //   },
              //   appContext: context,
              // ),

              Spaces.y1_0,
              Text(
                'verification_desc'.tr +
                    controller.formKey.currentState!.value['email'],
              ),

              /// Email OTP label
              /// if selected user is not user then this email verification will be visible
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spaces.y4,
                  CustomLabelField(labelText: 'code'.tr),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyles.normalBlackBodyText.copyWith(
                        fontSize: Spaces.normSP(14.5),
                        fontFamily: FontConstants.montserratRegular),
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeFillColor: Colors.transparent,
                      selectedFillColor: Colors.transparent,
                      selectedColor: ColorConstants.appBlack,
                      disabledColor: Colors.transparent,
                      inactiveColor: ColorConstants.appBlack,
                      inactiveFillColor: Colors.transparent,
                      errorBorderColor: ColorConstants.redButtonBackground,
                      activeColor: ColorConstants.appBlack,
                      borderWidth: Spaces.normX(0.3),
                      fieldWidth: Spaces.normX(13),
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _emailController,
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                ],
              ),

              /// Continue button
              Spaces.y2_0,
              CustomElevatedButton(
                  text: 'continue'.tr,
                  onPressed: () {
                    // if (controller.selectedUser == UserType.coach) {
                    if (_emailController.text.isEmpty) {
                      Utils.showSnack(
                        'alert'.tr,
                        'both_field_required'.tr,
                        isError: true,
                      );
                      return;
                    }
                    //   if (_emailController.text.length < 6) {
                    //     Utils.showSnack(
                    //       'alert'.tr,
                    //       'Code must be at least 6 digits',
                    //       isError: true,
                    //     );
                    //     return;
                    //   }
                    // }
                    // if (controller.selectedUser == UserType.user) {
                    //   if (_smsController.text.isEmpty) {
                    //     Utils.showSnack(
                    //       'alert'.tr,
                    //       'sms_field_required'.tr,
                    //       isError: true,
                    //     );
                    //     return;
                    //   }
                    // }

                    ///common in both sections
                    if (_emailController.text.length < 6) {
                      Utils.showSnack(
                        'alert'.tr,
                        'Code must be at least 6 digits',
                        isError: true,
                      );
                      return;
                    }

                    controller.verifyCode(
                      _smsController.text,
                      _emailController.text,
                    );
                  }),

              /// Resend Code button
              Spaces.y2,
              Obx(
                () => TextButton(
                  child: Text('resend_code'.tr),
                  onPressed: controller.showResendButton.value
                      ? () => controller.verifyPhoneAndEmail()
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

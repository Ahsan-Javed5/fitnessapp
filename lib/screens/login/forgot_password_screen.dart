import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/login/login_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Main title
            Text(
              'forgot_password'.tr,
              style: Get.textTheme.headline1,
            ),
            Spaces.y1_0,
            Text('forgot_password_desc'.tr),

            ///filed to enter user name no longer required has been changed to phone number
            FormBuilder(
              key: formKey,
              // child: FormPhoneBuilder(
              //   name: 'phone_number',
              //   labelText: 'phone_number'.tr,
              //   validator: FormBuilderValidators.compose([
              //     FormBuilderValidators.required(
              //       context,
              //       errorText: 'phone_number_required'.tr,
              //     ),
              //     FormBuilderValidators.numeric(
              //       context,
              //       errorText: 'invalid_phone'.tr,
              //     ),
              //   ]),
              // ),
              child: FormInputBuilder(
                attribute: 'username',
                labelText: 'user_name'.tr,
                fillColor: ColorConstants.appBlack,
                textCapitalization: TextCapitalization.none,
                maxLength: 30,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[A-Za-z0-9_.]'),
                  )
                ],
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      context,
                      errorText: 'username_required'.tr,
                    ),
                  ],
                ),
              ),
            ),

            Spaces.y4,
            CustomElevatedButton(
                text: 'send'.tr,
                onPressed: () async {
                  bool check = formKey.currentState!.saveAndValidate();
                  if (check) {
                    await LoginController()
                        .sendForgotPasswordRequest(formKey.currentState!.value);
                    formKey.currentState!.reset();
                  }
                }),
            Spaces.y4,
          ],
        ),
      ),
    );
  }
}

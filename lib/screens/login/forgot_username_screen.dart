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

class ForgotUserNameScreen extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  ForgotUserNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Main title
                Text(
                  'forgot_username'.tr,
                  style: Get.textTheme.headline1,
                ),
                Spaces.y1_0,
                Text('forgot_username_desc'.tr),

                ///design has been updated email no longer required for forget user name
                // FormInputBuilder(
                //   attribute: 'email',
                //   labelText: 'email'.tr,
                //   textCapitalization: TextCapitalization.none,
                //   keyboardType: TextInputType.emailAddress,
                //   textInputAction: TextInputAction.done,
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(
                //       context,
                //       errorText: 'email_required'.tr,
                //     ),
                //     FormBuilderValidators.email(
                //       context,
                //       errorText: 'invalid_email_err'.tr,
                //     ),
                //   ]),
                // ),

                ///phone  num
                FormInputBuilder(
                  attribute: 'email',
                  labelText: 'email'.tr,
                  fillColor: ColorConstants.appBlack,
                  textCapitalization: TextCapitalization.none,
                  maxLength: 30,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_@.]'))
                  ],
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: 'email_required'.tr,
                      ),
                    ],
                  ),
                ),
                // FormPhoneBuilder(
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

                Spaces.y4,
                CustomElevatedButton(
                    text: 'send'.tr,
                    onPressed: () async {
                      formKey.currentState!.save();
                      bool check = formKey.currentState!.validate();
                      if (check) {
                        await LoginController().sendForgotUserNameRequest(
                            formKey.currentState!.value);
                      }
                    }),
                Spaces.y4,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fitnessapp/config/form_validators.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/screens/resetPassword/restset_password_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/password_field_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  ResetPasswordScreen({Key? key}) : super(key: key);
  final controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      hasSearchBar: false,
      hasBackButton: true,
      hasRightButton: true,
      rightButton: const HomeButton(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.y3,

              /// Main title
              Text(
                'reset_password'.tr,
                style: Get.textTheme.headline1,
              ),

              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    /// Password field
                    Spaces.y2,
                    PasswordBuilder(
                      labelText: 'current_password'.tr,
                      name: 'current_password',
                      validator:
                          MyFormValidators.passwordValidators(context: context),
                    ),
                    PasswordBuilder(
                      labelText: 'new_password'.tr,
                      name: 'new_password',
                      validator:
                          MyFormValidators.passwordValidators(context: context),
                    ),
                    PasswordBuilder(
                      labelText: 'confirm_new_password'.tr,
                      name: 'confirm_new_password',
                      validator:
                          MyFormValidators.passwordValidators(context: context),
                    ),
                  ],
                ),
              ),

              /// Confirm password
              Spaces.y6,
              CustomElevatedButton(
                  text: 'update'.tr,
                  onPressed: () {
                    if (formKey.currentState!.saveAndValidate()) {
                      Map map = formKey.currentState!.value;
                      String password = map['new_password'];
                      String conPassword = map['confirm_new_password'];
                      if (password == conPassword) {
                        controller.restPassWord(formKey.currentState!.value);
                      } else {
                        Utils.showSnack('alert'.tr, 'password_must_be_same'.tr);
                      }
                    }
                  }),

              /// Resend Code button
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

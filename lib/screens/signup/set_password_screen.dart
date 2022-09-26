import 'package:fitnessapp/config/form_validators.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/screens/auth_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/actionBars/back_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/password_field_builder.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SetPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  SetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    String _password = '';
    String _confirmPassword = '';
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.y4,
              const BackAndRightActionBar(),

              Spaces.y3,

              /// Main title
              Text(
                'set_your_password'.tr,
                style: Get.textTheme.headline1,
              ),

              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    /// Password field
                    Spaces.y2,
                    PasswordBuilder(
                      labelText: 'password'.tr,
                      name: 'password',
                      onChange: (s) => _password = s!,
                      validator:
                          MyFormValidators.passwordValidators(context: context),
                    ),
                    PasswordBuilder(
                      labelText: 'confirm_password'.tr,
                      onChange: (s) => _confirmPassword = s!,
                      validator:
                          MyFormValidators.passwordValidators(context: context),
                    ),
                  ],
                ),
              ),

              /// Confirm password
              Spaces.y6,
              Obx(
                () => CustomElevatedButton(
                    text: 'confirm'.tr,
                    enabled: controller.buttonIsEnabled.value,
                    onPressed: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        if (_password.isNotEmpty &&
                            (_password == _confirmPassword)) {
                          controller.password = _confirmPassword;
                          controller.signUp();
                        } else {
                          Utils.showSnack('error'.tr, 'Password did not match');
                        }
                      }
                    }),
              ),

              /// Resend Code button
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

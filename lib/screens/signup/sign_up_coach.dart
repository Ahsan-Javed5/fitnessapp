import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/signup/sign_up_form.dart';
import 'package:fitnessapp/widgets/actionBars/menu_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class SignUpCoach extends StatelessWidget {
  final VoidCallback? callback;

  const SignUpCoach({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    controller.getAllCountries();
    controller.getWorkoutTypes();
    controller.selectedUser = UserType.coach;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              /// Top padding
              Spaces.y0,

              /// App bar
              MenuAndRightActionBar(
                showRightButton: true,
                rightButtonText: 'log_in'.tr,
                rightButtonClickListener: () {
                  Get.toNamed(Routes.loginScreen);
                },
                leftButtonClickListener: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  callback!();
                },
              ),

              /// Title and Contact us row
              Spaces.y2,
              Text(
                'sign_up'.tr,
                style: Get.textTheme.headline1,
              ),

              /// Title's desc
              Spaces.y1_0,
              Text('sign_up_desc'.tr),

              /// Signup form
              Spaces.y1,
              SignUpForm(
                formKey: controller.formKey,
                signUpAsUser: false,
              ),
              Spaces.y5,
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

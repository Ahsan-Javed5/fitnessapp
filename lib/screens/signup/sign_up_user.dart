import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/auth_controller.dart';
import 'package:fitnessapp/screens/signup/sign_up_form.dart';
import 'package:fitnessapp/widgets/actionBars/menu_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpUser extends StatelessWidget {
  final VoidCallback? callback;

  const SignUpUser({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    controller.getAllCountries();
    controller.selectedUser = UserType.user;

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
              /*BackAndRightActionBar(
                showRightButton: true,
                rightButtonText: 'log_in'.tr,
                rightButtonClickListener: () => Get.toNamed(Routes.loginScreen),
              ),*/

              MenuAndRightActionBar(
                showRightButton: true,
                rightButtonText: 'log_in'.tr,
                rightButtonClickListener: () {
                  Get.offAllNamed(Routes.loginScreen);
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
              Text('sign_up_as_user'.tr),

              /// Signup form
              Spaces.y1,
              SignUpForm(
                formKey: controller.formKey,
              ),
              Spaces.y2_0,
              Spaces.y2_0,
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

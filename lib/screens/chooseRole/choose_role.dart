import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/widgets/buttons/cutom_outlined_button.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.y7,

              /// Main title
              Text(
                'choose_your_role'.tr,
                style: Get.textTheme.headline1,
              ),

              const Spacer(),

              CustomOutlinedButton(
                  text: 'sign_up_as_user'.tr,
                  onPressed: () => Routes.offTo(Routes.signUpUser)),
              Spaces.y2,
              CustomOutlinedButton(
                  text: 'sign_up_as_coach'.tr,
                  onPressed: () => Routes.offTo(Routes.signUpCoach)),

              const Spacer(),
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

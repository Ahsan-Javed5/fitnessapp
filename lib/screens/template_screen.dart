import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spaces.y10,

            /// Main title
            Text(
              'choose_your_role'.tr,
              style: Get.textTheme.headline1,
            ),

            Spaces.y2_0,

            const Spacer(),
            CustomElevatedButton(text: 'continue'.tr, onPressed: () {}),
            Spaces.y4,
          ],
        ),
      ),
    );
  }
}

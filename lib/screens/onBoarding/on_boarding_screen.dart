import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      hasRightButton: false,
      hasSearchBar: false,
      includeBodyPadding: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spaces.y2,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Text(
                  'welcome_to'.tr + '\nFit and More',
                  style: Get.textTheme.headline1,
                ),
              ),
              Spaces.y4,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Text(
                  'on_boarding_des'.tr,
                ),
              ),
              Spaces.y4,
              Image.asset(
                'assets/images/on_boarding_shape.png',
                height: 20.h,
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(3.h),
                child: CustomElevatedButton(
                    text: 'continue'.tr,
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(Routes.home);
                    }),
              )
            ],
          ),
          Positioned(
            right: 0,
            bottom: 13.h,
            child: Image.asset(
              'assets/images/on_boarding_shape_big.png',
              height: 45.h,
            ),
          )
        ],
      ),
    );
  }
}

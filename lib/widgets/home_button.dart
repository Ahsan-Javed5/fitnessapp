import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SvgPicture.asset(
        'assets/svgs/ic_home.svg',
        color: ColorConstants.appBlack,
      ),
      onTap: () => Get.until((route) => (Get.currentRoute == Routes.home ||
          Get.currentRoute == Routes.loginScreen)),
    );
  }
}

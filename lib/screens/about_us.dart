import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'termsCondition/matrix_controller.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(MatrixController());
    _controller.fetchMatrixData('about_us');

    return CustomScreen(
      hasRightButton: MyHive.getUserType() == UserType.noUser ? false : true,
      rightButton: const HomeButton(),
      hasSearchBar: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Main title
              Spaces.y2_0,
              Text(
                'about_us'.tr,
                style: Get.textTheme.headline1,
              ),

              SizedBox(
                height: 2.0.h,
              ),

              /// body
              Obx(
                () => HtmlWidget(
                  _controller.matrixValue.value,
                ),
              ),
              SizedBox(
                height: 3.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

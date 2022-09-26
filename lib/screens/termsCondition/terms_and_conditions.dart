import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'matrix_controller.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(MatrixController());
    _controller.fetchMatrixData('terms_and_conditions');

    final hideHomeButton = Get.arguments?['hideHomeButton'] ?? false;

    return CustomScreen(
      hasRightButton: true,
      rightButton: hideHomeButton ? const SizedBox() : const HomeButton(),
      hasSearchBar: false,
      hasBackButton: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Main title
              Spaces.y2_0,
              Text(
                'terms_and_conditions'.tr,
                style: Get.textTheme.headline1,
              ),

              SizedBox(
                height: 2.0.h,
              ),

              /// body
              /*Obx(
                () => Text(
                  _controller.matrixValue.value,
                  textAlign: TextAlign.justify,
                ),
              ),*/

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

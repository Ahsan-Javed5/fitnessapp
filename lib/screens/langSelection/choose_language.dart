import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/screens/langSelection/choose_language_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spaces.y10,
            Spaces.y2_0,

            /// Main title
            Text(
              'language'.tr,
              style: Get.textTheme.headline1,
            ),

            SizedBox(
              height: 2.0.h,
            ),

            /// Title's body
            Text('lang_desc'.tr),

            SizedBox(
              height: 3.0.h,
            ),

            GetBuilder<ChooseLanguageController>(
              init: ChooseLanguageController(),
              builder: (controller) {
                var _radioGroupValue = controller.selectedLocale;

                /// Radio Group
                return Expanded(
                  child: Column(
                    children: [
                      _generateRadioButton(
                          'english'.tr,
                          LocaleType.en,
                          _radioGroupValue,
                          (value) => controller.updateLocale(value)),
                      _generateRadioButton(
                          'arabic'.tr,
                          LocaleType.ar,
                          _radioGroupValue,
                          (value) => controller.updateLocale(value)),
                      const Spacer(),
                      CustomElevatedButton(
                          text: 'continue'.tr,
                          onPressed: () {
                            MyHive.setLocaleSelected();
                            Get.toNamed(Routes.loginScreen);
                          }),
                      SizedBox(
                        height: 4.0.h,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _generateRadioButton(String text, LocaleType value, LocaleType groupValue,
      Function clickHandler) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 5.0.w,
          height: 10.5.w,
          child: Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => clickHandler(v),
          ),
        ),
        SizedBox(
          width: 4.0.w,
        ),
        Text(
          text,
          style: Get.textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

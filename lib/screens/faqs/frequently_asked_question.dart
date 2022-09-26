import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/faqs/faq_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/expandable_widget.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrequentlyAskedQuestions extends StatelessWidget {
  FrequentlyAskedQuestions({Key? key}) : super(key: key);

  final _controller = Get.put(FAQController());

  @override
  Widget build(BuildContext context) {
    _controller.fetchFAQs();

    return CustomScreen(
      hasRightButton: MyHive.getUserType() == UserType.noUser ? false : true,
      rightButton: const HomeButton(),
      hasSearchBar: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spaces.y4,

                  /// Main title
                  Text(
                    'faqs_title'.tr,
                    style: Get.textTheme.headline1,
                  ),

                  Spaces.y2,

                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _controller.faqs.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ExpandableCard(
                          title: _controller.faqs[index].question ?? '',
                          desc: _controller.faqs[index].answer ??
                              'not_answered_yet'.tr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Button
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(Spaces.normX(0.0),
                  Spaces.normY(2.0), Spaces.normX(0.0), Spaces.normY(3.0)),
              color: ColorConstants.whiteColor,
              child: CustomElevatedButton(
                  text: 'faqs_btn_title'.tr,
                  onPressed: () => Get.toNamed(Routes.askQuestionPage)),
            ),
          ],
        ),
      ),
    );
  }
}

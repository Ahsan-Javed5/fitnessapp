import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileSetupScreen extends StatelessWidget {
  ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileSetupController());
    c.init();
    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(
          () => WillPopScope(
            onWillPop: () {
              c.navigateBack();
              return Future.value(false);
            },
            child: Column(
              children: [
                /// Top header
                Spaces.y4,
                Padding(
                  padding: Spaces.getHoriPadding(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Back button
                      SizedBox(
                        width: Spaces.normX(8),
                        child: IconButton(
                          onPressed: () => c.navigateBack(),
                          icon: SvgPicture.asset(
                            'assets/svgs/ic_arrow.svg',
                            matchTextDirection: true,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      /// Title
                      Expanded(
                        child: Center(
                          child: Text(
                            'profile_set_up'.tr,
                            style: TextStyles.subHeadingWhiteMedium.copyWith(
                              color: ColorConstants.appBlack,
                              fontSize: Spaces.normSP(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Step presenter
                Padding(
                  padding: Spaces.getHoriPadding(),
                  child: SizedBox(
                    height: Spaces.normY(0.6),
                    child: ListView.builder(
                      itemCount: c.fragments.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return StepListItem(
                          index: index,
                          currentPageIndex: c.currentIndex.value,
                        );
                      },
                    ),
                  ),
                ),

                /// Showing fragment here
                Spaces.y2_0,
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Padding(
                      // Because page at index 1 has a fully expanded container according to the design
                      padding: c.currentIndex.value == 1
                          ? EdgeInsets.zero
                          : Spaces.getHoriPadding(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: c.fragments[c.currentIndex.value],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepListItem extends StatelessWidget {
  final int index;
  final int currentPageIndex;

  const StepListItem(
      {Key? key, required this.index, required this.currentPageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFilled = (index == currentPageIndex) || (index < currentPageIndex);
    return Container(
      margin: EdgeInsetsDirectional.only(end: Spaces.normX(2.0)),
      width: Spaces.normX(21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spaces.normX(4)),
        color: isFilled ? ColorConstants.appBlue : ColorConstants.grayLevel5,
      ),
    );
  }
}

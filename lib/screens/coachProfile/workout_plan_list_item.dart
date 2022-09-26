import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/user/coach_groups_count_list.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/dialogs/login_to_continue_dialog.dart';
import 'package:fitnessapp/widgets/dialogs/subscription/subscribe_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkoutPlanListItem extends StatelessWidget {
  final int index;
  final bool isSubscribed;
  final List<CoachGroupCount> countList;
  final User userData;

  const WorkoutPlanListItem(
      {Key? key,
      required this.index,
      this.isSubscribed = false,
      required this.countList,
      required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? tagText;
    String? routeName;
    bool isFree = index == 0 ? true : false;
    var startSpace = 3.0.w;
    if (Utils.isRTL()) {
      startSpace = 6.0.w;
    }

    bool showSubscriptionDialog = false;
    Map<String, dynamic>? arguments;
    if (isFree) {
      /// if plan is free then we will show and routes these below settings no matter what
      //tagText = 'free'.tr;
      tagText = null;
      routeName = Routes.workoutGroupScreen;
      arguments = {'mainGroup': countList[0]};
    } else if (Utils.isGuest()) {
      /// user type is guest and plan type is paid
      tagText = 'login_to_view'.tr;
      routeName = null;
      arguments = null;
    } else if (isSubscribed || Utils.isUserAdmin()) {
      tagText = null;
      routeName = Routes.workoutGroupScreen;
      arguments = {'mainGroup': countList[1]};
    } else if (!isSubscribed) {
      tagText = 'subscribe_to_continue'.tr;
      routeName = null;
      arguments = null;
      showSubscriptionDialog = true;
    }

    /// because free will be true if the user is subscriber and plan is free
    /// but we don't wanna show free label if user is subscribed above conditions will work in this case
    if (isSubscribed) tagText = null;
    return GestureDetector(
      onTap: () {
        if (routeName != null) {
          Get.toNamed(routeName, arguments: arguments);
        } else if (showSubscriptionDialog) {
          if (Utils.isCoach()) {
            Utils.showSnack('alert'.tr, 'Sign in as user to see these plan');
            return;
          }
          showDialog(
            context: context,
            useRootNavigator: true,
            useSafeArea: false,
            builder: (context) => SubscribeDialog(
              userData: userData,
              cancelListener: () => Get.back(),
              subscribeListener: () {
                MyHive.setSubscriptionType(SubscriptionType.subscribed);
                Get.offAllNamed(Routes.home);
              },
            ),
          );
        } else {
          if (Utils.isGuest()) _showLoginPopup(context);
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: startSpace, end: 3.0.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: SizedBox(
                  width: 76.w,
                  height: 30.h,
                  child: DataUtils.matrixList != null &&
                          DataUtils.matrixList.length > 0
                      ? CustomNetworkImage(
                          imageUrl: index == 0
                              ? DataUtils.matrixList[0].value
                              : DataUtils.matrixList[1].value,
                        )
                      : Image.asset(
                          index == 0
                              ? 'assets/images/free.png'
                              : 'assets/images/dummy_group.png',
                          fit: BoxFit.cover,
                        )),
            ),
          ),

          Container(
            width: 76.w,
            height: 30.h,
            margin: EdgeInsetsDirectional.only(start: startSpace, end: 3.0.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              gradient: LinearGradient(
                colors: [
                  ColorConstants.appBlue.withOpacity(0.8),
                  Colors.transparent,
                ],
                end: AlignmentDirectional.topCenter,
                begin: AlignmentDirectional.bottomCenter,
              ),
            ),
          ),

          /// Free or Login to view
          if (tagText != null && index > 0)
            PositionedDirectional(
              end: 6.0.w,
              top: 1.5.h,
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 3.0.w),
                decoration: BoxDecoration(
                  color: isFree
                      ? ColorConstants.veryVeryLightGray
                      : ColorConstants.redButtonBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: isFree
                          ? ColorConstants.veryLightBlue
                          : Colors.transparent),
                ),
                child: Text(
                  tagText,
                  style: TextStyles.normalWhiteBodyText.copyWith(
                    fontSize: 11.0.sp,
                    color: isFree ? ColorConstants.appBlue : Colors.white,
                  ),
                ),
              ),
            ),

          PositionedDirectional(
            start: MyHive.getLocaleType() == LocaleType.ar ? 6.0.w : 3.0.w,
            bottom: 3.0.h,
            width: 76.w,
            child: Container(
              width: 76.w,
              height: 15.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(2.w),
                    bottomRight: Radius.circular(2.w)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorConstants.appBlack.withOpacity(0.03),
                    ColorConstants.appBlack.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          /// Plan details
          PositionedDirectional(
            start: MyHive.getLocaleType() == LocaleType.ar ? 8.0.w : 5.0.w,
            bottom: 6.0.h,
            width: 33.0.h,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'group_content'.tr,
                  style: TextStyles.subHeadingWhiteMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 1.3.h,
                ),
                Text(
                  '${countList[index].count} ${'workout_groups'.tr}',
                  style: TextStyles.normalGrayBodyText.copyWith(
                      fontSize: 9.5.sp,
                      color: ColorConstants.whiteLevel2,
                      fontFamily: FontConstants.montserratRegular),
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Visibility(
                  visible: index == 1 ? true : false,
                  child: Text(
                    index == 1
                        ? '${countList[4].count} ${'workout_sub_groups'.tr}'
                        : '',
                    style: TextStyles.normalGrayBodyText.copyWith(
                        fontSize: 9.5.sp,
                        color: ColorConstants.whiteLevel2,
                        fontFamily: FontConstants.montserratRegular),
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  index == 0
                      ? '${countList[2].count} ${'videos'.tr}'
                      : '${countList[3].count} ${'videos'.tr}',
                  style: TextStyles.normalGrayBodyText.copyWith(
                      fontSize: 9.5.sp,
                      color: ColorConstants.whiteLevel2,
                      fontFamily: FontConstants.montserratRegular),
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (context) {
        return const LoginToContinueDialog();
      },
    );
  }
}

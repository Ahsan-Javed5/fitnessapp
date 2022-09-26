import 'package:country_pickers/country_pickers.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/screens/coachProfile/coach_profile_controller.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/screens/coachProfile/workout_plan_list_item.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/dialogs/subscription/subscribe_dialog.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:fitnessapp/widgets/note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../video_player_screen.dart';

////////////////////////////////////////////////
//                                            //
//        Others will see this Profile        //
//                                            //
////////////////////////////////////////////////

/// [Utils.isSubscribedUser()] checks if the [UserType == UserType.User] and SubscriptionType == Subscribed
/// [Utils.isUnSubscribedUser()] checks if the [UserType == UserType.User] and SubscriptionType == UnSubscribed
/// if user is unsubscribed then show unsubscribe ui which show button to subscribe and note and free and click to subscribe tags
/// else if user is subscribed show subscription ui which is remove free and click to subscribe tags
///
/// this screen shows free and paid plans
/// free plans are available to everyone no matter what
/// paid plans obviously will be available to user who have subscription

class CoachProfile extends StatelessWidget {
  CoachProfile({Key? key}) : super(key: key);

  final controller = Get.put(CoachProfileController());

  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());
  final videoListController = Get.put(VideoListController());

  @override
  Widget build(BuildContext context) {
    final CoachProfileController controller = Get.find();
    controller.coachData = Get.arguments?['data'];
    controller.getCurrency();
    if (controller.coachData?.isSubscribed ?? false) {
      MyHive.setSubscriptionType(SubscriptionType.subscribed);
    } else {
      MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
    }
    //Setting coach ID to each
    if (controller.coachData?.countList != null &&
        controller.coachData!.countList!.isNotEmpty) {
      for (var i = 0; i < controller.coachData!.countList!.length; i++) {
        controller.coachData!.countList![i].coachId = controller.coachData?.id;
      }
    }

    videoListController.workoutProgramTypeString =
        controller.coachData?.userWorkoutProgramTypesToString();
    videoListController.coachFirebaseKey = controller.coachData?.firebaseKey;
    videoListController.isAllowChat = controller.isAllowPrivateChat();

    //https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4

    return GradientBackground(
      includePadding: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              /// Video background
              PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                key: UniqueKey(),
                child: GestureDetector(
                    onTap: () {
                      String videoUrl =
                          controller.coachData?.coachIntroVideo?.videoUrl ?? '';
                      if (videoUrl.isEmpty) {
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (context) => VideoPlayerScreen(
                                url: controller
                                        .coachData?.coachIntroVideo?.videoUrl ??
                                    '',
                                videoId:
                                    controller.coachData?.coachIntroVideo?.id ??
                                        -1,
                                processStatus: controller.coachData
                                        ?.coachIntroVideo?.isProcessed ??
                                    1,
                                videoStreamUrl: controller.coachData
                                        ?.coachIntroVideo?.videoStreamUrl ??
                                    '',
                                ifCoachIntroVideoThenId:
                                    controller.coachData?.id!.toString(),
                              ),
                          useSafeArea: false);
                    },
                    key: UniqueKey(),
                    child: CustomNetworkVideo(
                      width: 100.w,
                      height: 33.h,
                      fit: BoxFit.cover,
                      key: UniqueKey(),
                      thumbnail:
                          controller.coachData?.coachIntroVideo?.thumbnail ??
                              '',
                      url:
                          controller.coachData?.coachIntroVideo?.videoUrl ?? '',
                    )),
              ),

              /// Back button
              PositionedDirectional(
                top: 0,
                start: 0,
                child: IconButton(
                  iconSize: 5.0.h,
                  padding: EdgeInsetsDirectional.only(top: 4.0.h, start: 4.0.w),
                  icon: SvgPicture.asset(
                    'assets/svgs/ic_back_elevated.svg',
                    matchTextDirection: true,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),

              /// Home button
              PositionedDirectional(
                top: 4.0.h,
                end: 3.0.h,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: EdgeInsets.all(0.8.h),
                    child: const HomeButton(),
                  ),
                ),
              ),

              PositionedDirectional(
                start: 0,
                end: 0,
                top: 32.h,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  height: 60.h,
                ),
              ),

              PositionedDirectional(
                start: 0,
                end: 0,
                top: 23.h,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    /// Profile image
                    ClipOval(
                      child: Container(
                        height: 16.9.h,
                        width: 16.9.h,
                        decoration: BoxDecoration(
                            color: ColorConstants.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstants.appBlue.withOpacity(1),
                                offset: const Offset(5, 80),
                                blurRadius: 80.5,
                              ),
                            ]),
                        child: CustomNetworkImage(
                            imageUrl: controller.coachData?.imageUrl ?? ''),
                      ),
                    ),

                    /// Coach name
                    Spaces.y1,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LimitedBox(
                          maxWidth: 85.w,
                          child: FittedBox(
                            child: Text(
                              controller.coachData?.getFullName() ?? '',
                              style: Get.textTheme.headline1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        if (controller.coachData?.isVerified ?? false)
                          SvgPicture.asset(
                            'assets/svgs/ic_verified.svg',
                            fit: BoxFit.scaleDown,
                          ),
                      ],
                    ),
                    Spaces.y1,
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Spaces.normY(46)),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///user profile bio
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        controller.coachData?.bio != null
                            ? controller.coachData!.bio!
                                .replaceAll(RegExp(r'\s+\b|\b\s'), ' ')
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyles.normalBlackBodyText,
                      ),
                    ),

                    /// Gender and Countr
                    Spaces.y0,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Gender
                        SvgPicture.asset(
                          'assets/svgs/ic_gender.svg',
                          height: 2.0.h,
                          matchTextDirection: true,
                          fit: BoxFit.scaleDown,
                        ),
                        SizedBox(
                          width: 1.5.w,
                        ),
                        Text(
                          controller.coachData?.gender?.toLowerCase().tr ??
                              'no_data'.tr,
                          style: TextStyles.normalBlackBodyText,
                        ),

                        SizedBox(
                          width: 4.0.w,
                        ),

                        /// Country
                        SizedBox(
                          height: 2.0.h,
                          width: 3.h,
                          child: controller.coachData?.country?.name != null &&
                                  controller.coachData?.country?.name
                                          ?.toLowerCase() !=
                                      'other'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: CountryPickerUtils.getDefaultFlagImage(
                                    CountryPickerUtils.getCountryByIso3Code(
                                        controller.coachData?.country?.iso ??
                                            ''),
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          width: 1.5.w,
                        ),
                        Text(
                          controller.coachData!.country!.name ?? '',
                          style: TextStyles.normalBlackBodyText,
                        ),
                      ],
                    ),
                    Spaces.y1,
                    Spaces.y0,

                    /// Strength workouts
                    NoteView(
                      text: controller.coachData
                              ?.userWorkoutProgramTypesToString() ??
                          '',
                      hasBorder: true,
                      verticalPadding: 0.5.h,
                      textColor: ColorConstants.appBlue,
                    ),

                    ///end
                    /// note for unsubscribed user
                    if (!controller.isGuest &&
                        Utils.isUser() &&
                        !controller.coachData!.isSubscribed!)
                      Container(
                        margin: EdgeInsets.only(
                            left: 5.w,
                            right: 5.w,
                            top: Utils.isRTL() ? 4.w : 0.w),
                        child: TextButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0.w, vertical: 2.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'unsubscribed_note'.tr,
                                    softWrap: true,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.textTheme.bodyText2!.copyWith(
                                      color: ColorConstants.appBlack,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomLabelField(
                                        labelText: 'subscription_fee'.tr,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${controller.coachData?.monthlySubscriptionPrice ?? 0}',
                                            style: TextStyles
                                                .normalBlackBodyText
                                                .copyWith(fontSize: 20.sp),
                                          ),
                                          // FittedBox(
                                          //   child: Obx(() {
                                          //     return Text(
                                          //         controller.getLocalRate(
                                          //             controller.coachData
                                          //                     ?.monthlySubscriptionPrice ??
                                          //                 0,
                                          //             controller
                                          //                 .currencyModel.value),
                                          //         style: TextStyles
                                          //             .normalBlackBodyText);
                                          //   }),
                                          // ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: ColorConstants.veryVeryLightGray,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0)),
                          onPressed: null,
                        ),
                      ),

                    /// subscribe button for unsubscribed user
                    if (!controller.isGuest &&
                        Utils.isUser() &&
                        !controller.coachData!.isSubscribed!)
                      Container(
                        height: 4.h,
                        width: 58.w,
                        margin: EdgeInsets.only(top: 2.h),
                        child: CustomElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => SubscribeDialog(
                                userData: controller.coachData!,
                                cancelListener: () => Get.back(),
                                subscribeListener: () {
                                  //MyHive.setSubscriptionType(SubscriptionType.subscribed);
                                  //Get.offAllNamed(Routes.home);
                                },
                              ),
                              useSafeArea: false,
                            );
                          },
                          text: 'click_here_to_subscribe'.tr,
                          textStyle: TextStyles.normalWhiteBodyText,
                        ),
                      ),

                    /// subscription date range and chat button for subscribed user
                    if (!controller.isGuest &&
                        Utils.isUser() &&
                        controller.coachData!.isSubscribed!)
                      Container(
                        margin: EdgeInsets.only(
                            left: 6.w,
                            right: 6.w,
                            top: Utils.isRTL() ? 4.w : 1.w),
                        height: 8.h,
                        child: dateAndChatView(context),
                      ),

                    ///Workout plans
                    ///here
                    Spaces.y2_0,
                    Spaces.x7,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 4.0.w),
                        child: Text(
                          'workout_plans'.tr,
                          style: TextStyles.normalBlackBodyText.copyWith(
                              fontSize: 12.5.sp,
                              fontFamily: FontConstants.montserratMedium),
                        ),
                      ),
                    ),

                    Spaces.y2,
                    SizedBox(
                      height: 33.0.h,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        //itemCount: controller.coachData!.countList!.length,
                        itemCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return WorkoutPlanListItem(
                            index: index,
                            countList: controller.coachData!.countList!,
                            isSubscribed: controller.coachData!.isSubscribed!,
                            userData: controller.coachData!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// if coach allow private chat then show chat button otherwise hide chat button
  Widget dateAndChatView(BuildContext context) {
    if (controller.isAllowPrivateChat()) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // date range

          Expanded(
            child: NoteView(
              hasBorder: true,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'start_on'.tr.toUpperCase(),
                        style: TextStyles.normalGrayBodyText
                            .copyWith(fontSize: 7.sp),
                      ),
                      Text(
                        controller.coachData?.startsAt != null
                            ? Utils.formatDateTime(
                                controller.coachData!.startsAt!)
                            : '',
                        style: TextStyles.normalGrayBodyText.copyWith(
                            color: ColorConstants.appBlack, fontSize: 8.sp),
                      ),
                    ],
                  ),
                  Spaces.x5,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'end_date'.tr.toUpperCase(),
                        style: TextStyles.normalGrayBodyText
                            .copyWith(fontSize: 7.sp),
                      ),
                      Text(
                        controller.coachData?.endsAt != null
                            ? Utils.formatDateTime(
                                controller.coachData!.endsAt!)
                            : '',
                        style: TextStyles.normalGrayBodyText.copyWith(
                          color: ColorConstants.appBlack,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spaces.x3,

          // chat button
          SizedBox(
            width: 40.w,
            child: NoteView(
              verticalPadding: Utils.isRTL() ? 2.h : null,
              hasBorder: true,
              backgroundColor: Colors.transparent,
              onPress: () {
                Utils.open1to1Chat(MyHive.getUser()!.firebaseKey.toString(),
                    controller.coachData!.firebaseKey.toString(), context);
              },
              //Get.toNamed(Routes.chatMainScreen),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/ic_chat.svg',
                      color: ColorConstants.appBlue,
                      fit: BoxFit.scaleDown,
                    ),
                    Spaces.x4,
                    Text(
                      'chat'.tr,
                      style: TextStyles.normalBlueBodyText
                          .copyWith(fontSize: 12.5.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // date range
      return NoteView(
        hasBorder: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'start_on'.tr.toUpperCase(),
                  style: TextStyles.normalGrayBodyText.copyWith(fontSize: 7.sp),
                ),
                Text(
                  controller.coachData?.startsAt != null
                      ? Utils.formatDateTime(controller.coachData!.startsAt!)
                      : '',
                  style: TextStyles.normalGrayBodyText
                      .copyWith(color: ColorConstants.appBlack, fontSize: 8.sp),
                ),
              ],
            ),
            Spaces.x8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'end_date'.tr.toUpperCase(),
                  style: TextStyles.normalGrayBodyText.copyWith(fontSize: 7.sp),
                ),
                Text(
                  controller.coachData?.endsAt != null
                      ? Utils.formatDateTime(controller.coachData!.endsAt!)
                      : '',
                  style: TextStyles.normalGrayBodyText.copyWith(
                    color: ColorConstants.appBlack,
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

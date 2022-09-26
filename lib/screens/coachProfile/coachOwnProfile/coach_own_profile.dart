import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/coachProfile/coachOwnProfile/coach_own_profile_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/custom_network_video.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/dialogs/add_video_dialog.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/custom_label_field.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:fitnessapp/widgets/note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../video_player_screen.dart';

////////////////////////////////////////////////
//                                            //
//           Coach Own Profile View           //
//                                            //
////////////////////////////////////////////////

class CoachOwnProfile extends StatelessWidget {
  CoachOwnProfile({Key? key}) : super(key: key);
  final controller = Get.put(CoachOwnProfileController());
  final formKey = GlobalKey<FormBuilderState>();
  // final bioFormKey = GlobalKey<FormBuilderState>();
  var bioFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    User? user = MyHive.getUser();
    controller.updateLocalUser(user);
    var preferOTPDelivery = 'sms';
    var monthlySubsPrice = '0';
    preferOTPDelivery = controller.getPreferOTPDelivery();
    monthlySubsPrice =
        controller.getUser()!.monthlySubscriptionPrice!.toString();
    final allowPrivateQus = controller.getUser()!.allowPrivateChat!.obs;
    controller.getSubscriptionPrice();
    return CustomScreen(
      hasBackButton: true,
      hasSearchBar: false,
      hasRightButton: true,
      rightButton: const HomeButton(),
      children: [
        /// Top header with title and Profile image
        GetBuilder<CoachOwnProfileController>(
          init: controller,
          builder: (controller) => Row(
            children: [
              Text(
                'profile'.tr,
                style: TextStyles.mainScreenHeading,
              ),
              const Spacer(),

              /// change image label
              GestureDetector(
                onTap: () => controller.selectImage(),
                child: Text(
                  'change_image'.tr,
                  style: TextStyles.normalBlueBodyText.copyWith(
                    fontSize: Spaces.normSP(9),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Spaces.x3,
              GestureDetector(
                onTap: () => controller.selectImage(),
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        height: Spaces.normY(9.5),
                        width: Spaces.normY(9.5),
                        decoration: const BoxDecoration(
                          color: ColorConstants.imageBackground,
                        ),
                        child: controller.imageFile == null
                            ? CustomNetworkImage(
                                imageUrl: controller.getImagePath(),
                                useDefaultBaseUrl: false,
                              )
                            : Image.file(
                                controller.imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    PositionedDirectional(
                      end: 5,
                      bottom: 1,
                      child: SvgPicture.asset(
                        (MyHive.getUser()?.isVerified ?? false)
                            ? 'assets/svgs/ic_verified.svg'
                            : 'assets/svgs/ic_unverified.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Profile Details Gradient card
        ProfileDetailsCard(
          user: user,
        ),
        SizedBox(height: 3.0.h),
        CustomLabelField(labelText: 'bio'.tr.toUpperCase()),

        ///bio Field
        GetBuilder<CoachOwnProfileController>(
          builder: (_) {
            return FormBuilderTextField(
              name: 'coach_bio',
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              focusNode: bioFocusNode,
              onTap: () {
                changeBioFieldFocus();
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
                FilteringTextInputFormatter.deny('  ')
              ],
              controller: controller.coachBioController,
              // initialValue: controller.coachBio ?? user?.bio,
              minLines: 1,
              style: Get.textTheme.bodyText2!.copyWith(
                fontFamily: FontConstants.montserratRegular,
                fontWeight: FontWeight.bold,
                fontSize: 11.0.sp,
              ),
              decoration: InputDecoration(
                filled: false,
                isDense: false,
                counterText: '',
                suffixStyle: TextStyles.normalBlackBodyText,
                focusColor: ColorConstants.appBlack,
                fillColor: ColorConstants.appBlack,
                hoverColor: ColorConstants.appBlack,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConstants.appBlack,
                  ),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConstants.appBlack,
                  ),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConstants.appBlack,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConstants.appBlack,
                  ),
                ),
                hintText: 'enter_bio'.tr,
                hintStyle: Get.textTheme.bodyText2!.copyWith(
                  fontFamily: FontConstants.montserratRegular,
                  fontWeight: FontWeight.w300,
                  color: ColorConstants.bodyTextColor.withOpacity(0.6),
                  fontSize: 11.0.sp,
                ),
              ),
            );
          },
        ),

        /// Introduction Video Section
        Spaces.y1_0,
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'introduction_video'.tr.toUpperCase(),
                maxLines: 1,
                softWrap: true,
                style: TextStyles.normalGrayBodyText
                    .copyWith(fontSize: Spaces.normSP(10)),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _showAddIntroVideoDialog(context);
              },
              icon: SvgPicture.asset('assets/svgs/ic_upload.svg'),
              label: Text(
                'add_new'.tr,
                style: TextStyles.normalBlackBodyText.copyWith(
                  fontSize: Spaces.normSP(9),
                ),
              ),
            ),
            Spaces.x2,
            TextButton.icon(
              onPressed: () {
                _removeIntroVideo();
              },
              icon: SvgPicture.asset('assets/svgs/ic_close_circled.svg'),
              label: Text(
                'remove'.tr,
                style: TextStyles.normalBlackBodyText.copyWith(
                  fontSize: Spaces.normSP(9),
                ),
              ),
            ),
          ],
        ),

        Spaces.y1_0,
        GetBuilder<CoachOwnProfileController>(
          id: 'introBuilder',
          builder: (c) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  introVideoImage(),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (hasIntroVideo()) {
                            showDialog(
                                context: context,
                                builder: (context) => VideoPlayerScreen(
                                      url: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.videoUrl ??
                                          '',
                                      videoId: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.id ??
                                          -1,
                                      processStatus: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.isProcessed ??
                                          1,
                                      videoStreamUrl: MyHive.getUser()!
                                              .coachIntroVideo
                                              ?.videoStreamUrl ??
                                          '',
                                      ifCoachIntroVideoThenId:
                                          MyHive.getUser()!.id!.toString(),
                                    ),
                                useSafeArea: false);
                          } else {
                            Utils.showSnack(
                                'alert'.tr, 'no_intro_video_found'.tr);
                          }
                        },
                        child: hasIntroVideo()
                            ? SvgPicture.asset(
                                'assets/svgs/ic_video_play.svg',
                                fit: BoxFit.scaleDown,
                              )
                            : const SizedBox()),
                  )
                ],
              ),
            );
          },
        ),

        Spaces.y2_0,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: Spaces.normX(43),
            height: Spaces.normY(4.3),
            child: CustomElevatedButton(
              text: 'reset_password'.tr,
              onPressed: () => Get.toNamed(Routes.resetPasswordScreen),
            ),
          ),
        ),

        /// Monthly subscription price
        Spaces.y5,
        Text(
          'monthly_subscription_price'.tr,
          style: TextStyles.subHeadingWhiteMedium.copyWith(
            color: ColorConstants.appBlack,
            fontSize: Spaces.normSP(13),
          ),
        ),
        FormBuilder(
          key: formKey,
          child: Obx(() {
            return FormInputBuilder(
              labelText: 'price'.tr,
              attribute: 'price',
              maxLength: 3,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money_outlined),
              initialValue:
                  controller.getUser()!.monthlySubscriptionPrice.toString(),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(
                    context,
                    errorText: 'this_field_is_required'.tr,
                  ),
                  FormBuilderValidators.min(
                    context,
                    int.tryParse(controller.subscriptionPrice.value) ?? 0,
                  ),
                  FormBuilderValidators.numeric(
                    context,
                    errorText: 'invalid_value'.tr,
                  ),
                ],
              ),
              onChanged: (val) {
                monthlySubsPrice = val.toString().trim();
              },
            );
          }),
        ),
        Spaces.y2,
        Obx(() {
          return NoteView(
            text: Utils.isRTL()
                ? 'مبلغ الاشتراك الشهري (يجب ألا يقل عن ' +
                    controller.subscriptionPrice.value +
                    ' دولار)'
                : 'Monthly subscription amount (should not be less than \$${controller.subscriptionPrice.value})',
            hasBorder: true,
            textColor: ColorConstants.appBlue,
            textSize: Spaces.normSP(9),
            verticalPadding: Spaces.normY(0.5),
          );
        }),

        Spaces.y3,
        Obx(() {
          return CheckboxListTile(
            value: allowPrivateQus.value,
            onChanged: (b) {
              allowPrivateQus.value = b!;
            },
            dense: true,
            title: Text(
              'allow_private_question'.tr,
              textAlign: TextAlign.start,
              style: TextStyles.normalBlackBodyText,
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),

        /// Preferred OTP Delivery
        /// Its no longer needed
        /*Spaces.y3,
        Text(
          'preferred_otp_delivery'.tr,
          style: TextStyles.subHeadingWhiteMedium.copyWith(
              color: ColorConstants.appBlack, fontSize: Spaces.normSP(13)),
        ),
        Spaces.y1,*/

        /// Radio Buttons for preferred OTP Delivery
        /*Theme(
          data: getAppThemeData()
              .copyWith(unselectedWidgetColor: ColorConstants.bodyTextColor),
          child: FormBuilderRadioGroup(
              name: 'OTP',
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              wrapAlignment: WrapAlignment.spaceBetween,
              initialValue: controller.getPreferOTPDelivery(),
              wrapCrossAxisAlignment: WrapCrossAlignment.start,
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                border: InputBorder.none,
                focusColor: ColorConstants.appBlack,
                filled: true,
                isDense: false,
                contentPadding: EdgeInsets.zero,
              ),
              options: ['sms', 'email', 'both']
                  .map(
                    (option) => FormBuilderFieldOption(
                      value: option,
                      child: Text(
                        option.tr,
                        style: TextStyles.normalBlackBodyText,
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (val) {
                preferOTPDelivery = val.toString();
              }),
        ),*/

        /// Save button
        Spaces.y4,
        CustomElevatedButton(
            text: 'save'.tr,
            onPressed: () {
              Utils.hideKeyboard(context);
              if (!formKey.currentState!.saveAndValidate()) return;
              changeBioFieldFocus();
              Map<String, dynamic> body = {};
              body['selected_language'] = 'English';
              body['preffered_OTP_delivery'] = preferOTPDelivery;
              body['bio'] = controller.coachBioController.text;
              body['mounthly_subscription_price'] = monthlySubsPrice;
              body['allow_private_chat'] = allowPrivateQus.value;
              CoachOwnProfileController()
                  .updateUser(body, controller.imageFile);
            }),

        /// Bottom padding
        Spaces.y6,
      ],
    );
  }

  /// thumbnail of intro video or placeholder if video is not added
  Widget introVideoImage() {
    if (hasIntroVideo()) {
      return SizedBox(
        height: Spaces.normY(27),
        child: Material(
          elevation: 10,
          child: CustomNetworkVideo(
            width: Spaces.normX(95),
            height: Spaces.normY(27),
            fit: BoxFit.cover,
            url: controller.getUser()!.coachIntroVideo?.videoUrl ?? '',
            thumbnail: controller.getUser()!.coachIntroVideo?.thumbnail ?? '',
          ),
        ),
      );
    } else {
      return Image.asset(
        'assets/images/video_placeholder.png',
        height: Spaces.normY(27),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  bool hasIntroVideo() {
    return controller.getUser()!.coachIntroVideo != null &&
        controller.getUser()!.coachIntroVideo.toString().isNotEmpty;
  }

  ///bioField Focus
  void changeBioFieldFocus() {
    if (bioFocusNode.hasFocus) {
      bioFocusNode.unfocus();
    } else {
      if (bioFocusNode.canRequestFocus) {
        bioFocusNode.requestFocus();
      }
    }
  }

  /// Add intro video dialog
  void _showAddIntroVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (context) {
        return AddVideoDialog(mController: controller);
      },
    );
  }

  void _removeIntroVideo() {
    if (MyHive.getUser()!.coachIntroVideo != null) {
      controller.removeIntroVideo();
    } else {
      Utils.showSnack('alert'.tr, 'no_intro_video_found'.tr);
    }
  }
}

class ProfileDetailsCard extends StatelessWidget {
  final User? user;
  const ProfileDetailsCard({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Spaces.normY(3)),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.veryVeryLightGray),
        borderRadius: BorderRadius.circular(Spaces.normX(2)),
        color: ColorConstants.veryVeryLightGray,
      ),
      child: Column(
        children: [
          ProfileDetailListItem(title: 'username'.tr, value: user!.userName!),
          ProfileDetailListItem(
              title: 'first_name'.tr, value: user!.firstName!),
          ProfileDetailListItem(title: 'last_name'.tr, value: user!.lastName!),
          ProfileDetailListItem(
              title: 'country'.tr, value: user!.country?.name ?? 'No data'),
          ProfileDetailListItem(title: 'email'.tr, value: user!.email!),
          ProfileDetailListItem(
              title: 'contact_number'.tr, value: user!.phoneNumber!),
          ProfileDetailListItem(
              title: 'workout_program_types'.tr,
              value: user!.userWorkoutProgramTypesToString()),

          /// Contact admin note
          Spaces.y3,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spaces.normX(3)),
            child: NoteView(
              text: 'contact_admin_desc'.tr,
              hasBorder: true,
              backgroundColor: Colors.transparent,
              verticalPadding: Spaces.normY(1),
              textSize: Spaces.normSP(9),
              textColor: ColorConstants.appBlue,
            ),
          ),

          Spaces.y3,
          if (!Utils.isUserAdmin())
            Padding(
              padding: EdgeInsetsDirectional.only(end: Spaces.normX(4)),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SizedBox(
                  width: Spaces.normX(42),
                  height: Spaces.normY(4.3),
                  child: CustomElevatedButton(
                    text: 'contact_admin'.tr,
                    onPressed: () {
                      Utils.open1to1Chat(
                        user!.firebaseKey ?? '',
                        MyHive.adminFBEntityKey,
                        context,
                      );
                    },
                  ),
                ),
              ),
            ),

          Spaces.y3,
        ],
      ),
    );
  }
}

class ProfileDetailListItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailListItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
      margin: EdgeInsets.only(top: Spaces.normY(2)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title.toUpperCase(),
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 4,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.normalBlackBodyText
                  .copyWith(fontSize: Spaces.normSP(11.5)),
            ),
          ),
        ],
      ),
    );
  }
}

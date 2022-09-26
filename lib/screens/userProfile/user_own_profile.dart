import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/userProfile/user_profile_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:fitnessapp/widgets/note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

////////////////////////////////////////////////
//                                            //
//           User Own Profile View           //
//                                            //
////////////////////////////////////////////////

class UserOwnProfile extends StatelessWidget {
  UserOwnProfile({Key? key}) : super(key: key);

  // final controller = Get.put(CoachOwnProfileController());
  final userController = UserProfileController();

  @override
  Widget build(BuildContext context) {
    var preferOTPDelivery = 'sms';
    preferOTPDelivery = userController.getPreferOTPDelivery();
    return CustomScreen(
      hasBackButton: true,
      hasSearchBar: false,
      hasRightButton: true,
      rightButton: const HomeButton(),
      children: [
        /// Top header with title and Profile image
        GetBuilder<UserProfileController>(
          init: userController,
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
                      child: SvgPicture.asset('assets/svgs/ic_verified.svg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Profile Details Gradient card
        const ProfileDetailsCard(),

        /// Reset password
        Spaces.y2_0,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: Spaces.normX(42),
            height: Spaces.normY(4.3),
            child: OutlinedButton(
              onPressed: () => Get.toNamed(Routes.resetPasswordScreen),
              child: Text(
                'reset_password'.tr,
                style: TextStyles.normalBlueBodyText.copyWith(
                  fontSize: Spaces.normSP(12),
                  fontFamily: FontConstants.montserratMedium,
                ),
              ),
              style: Get.theme.outlinedButtonTheme.style
                  ?.copyWith(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ),
        ),

        /// Preferred OTP Delivery
        /// No longer needed
        /*  Spaces.y4,
        Text(
          'preferred_otp_delivery'.tr,
          style: TextStyles.subHeadingWhiteMedium.copyWith(
              color: ColorConstants.appBlack, fontSize: Spaces.normSP(12)),
        ),
        Spaces.y1,

        /// Radio Buttons
        Theme(
          data: getAppThemeData()
              .copyWith(unselectedWidgetColor: ColorConstants.dividerColor),
          child: FormBuilderRadioGroup(
            name: 'OTP',
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            wrapAlignment: WrapAlignment.spaceBetween,
            initialValue: userController.getPreferOTPDelivery(),
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
            },
          ),
        ),*/

        /// Save button
        Spaces.y4,
        CustomElevatedButton(
            text: 'save'.tr,
            onPressed: () {
              Map<String, dynamic> body = {};
              body['selected_language'] = 'English';
              body['preffered_OTP_delivery'] = preferOTPDelivery;

              UserProfileController()
                  .updateUser(body, userController.imageFile);
            }),

        /// Bottom padding
        Spaces.y6,
      ],
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = MyHive.getUser();

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
          ProfileDetailListItem(title: 'first_name'.tr, value: user.firstName!),
          ProfileDetailListItem(title: 'last_name'.tr, value: user.lastName!),
          ProfileDetailListItem(
              title: 'country'.tr, value: user.country?.name ?? 'No data'),
          if (MyHive.getUserType() != UserType.user)
            ProfileDetailListItem(title: 'email'.tr, value: user.email!),

          ProfileDetailListItem(
              title: 'contact_number'.tr, value: user.phoneNumber!),

          /// Contact admin note
          Spaces.y3,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spaces.normX(3)),
            child: NoteView(
              text: 'contact_admin_desc'.tr,
              hasBorder: true,
              backgroundColor: ColorConstants.veryLightBlue,
              verticalPadding: Spaces.normY(1),
              textSize: Spaces.normSP(9),
              textColor: ColorConstants.appBlue,
            ),
          ),

          Spaces.y3,
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
                      user.firebaseKey ?? '',
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
          Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.normalBlackBodyText
                .copyWith(fontSize: Spaces.normSP(11.5)),
          ),
        ],
      ),
    );
  }
}

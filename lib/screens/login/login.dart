import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/user/user_credentials.dart';
import 'package:fitnessapp/screens/login/login_controller.dart';
import 'package:fitnessapp/screens/login/login_form.dart';
import 'package:fitnessapp/widgets/actionBars/menu_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback? callback;

  LoginScreen({Key? key, this.callback}) : super(key: key);

  final formKey = GlobalKey<FormBuilderState>();
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    controller.checkBiometricsAvailableAndWasLoggedIn();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              /// Top padding
              Spaces.y0,

              /// App bar
              MenuAndRightActionBar(
                showRightButton: true,
                rightButtonText: 'sign_up'.tr,
                rightButtonClickListener: () {
                  Get.toNamed(Routes.chooseRole);
                },
                leftButtonClickListener: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  callback!();
                },
              ),
              Spaces.y2_0,

              /// Title and Contact us row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'log_in'.tr,
                      style: Get.textTheme.headline1,
                    ),
                  ),
                  ContactUsButton(
                    text: 'contact_us'.tr,
                    onPressed: () {
                      Get.toNamed(Routes.contactUs);
                    },
                  ),
                ],
              ),
              Spaces.y2_0,

              /// Title's desc
              Text('login_desc'.tr),

              /// Login form
              LoginForm(
                formKey: formKey,
                controller: controller,
              ),
              Spaces.y1_0,

              /// Forgot password
              Align(
                alignment: AlignmentDirectional.topStart,
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.forgotPasswordUserName),
                  child: Text('forgot_password_username'.tr),
                ),
              ),
              Spaces.y1,

              /// Face id view
              Obx(() {
                return Visibility(
                    visible: controller.isBiometricAvailable.value,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w, vertical: 2.h),
                      margin: EdgeInsets.symmetric(horizontal: 27.0.w),
                      decoration: BoxDecoration(
                          color: ColorConstants.veryVeryLightGray,
                          borderRadius: BorderRadius.circular(1.0.w),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorConstants.veryVeryLightGray,
                              offset: Offset(0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: ColorConstants.unSelectedWidgetColor
                              .withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            bool? isAuthenticated =
                                await controller.authenticateWithBiometrics();
                            if (isAuthenticated != null && isAuthenticated) {
                              UserCredentials? credentials =
                                  MyHive.getUserCredentials();
                              if (credentials != null) {
                                if (credentials.userName!.isEmpty ||
                                    credentials.password!.isEmpty) {
                                  return;
                                }
                                Map map = {};
                                map['user_name'] = credentials.userName;
                                map['password'] = credentials.password;

                                ///decrypt password
                                controller.login(map);
                              }
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/ic_face_id.svg',
                                color: ColorConstants.appBlue,
                              ),
                              Spaces.y2,
                              Text(
                                'user_face_id'.tr,
                                style: TextStyles.textFieldLabelStyleSmallGray
                                    .copyWith(
                                        color: ColorConstants.appBlue,
                                        fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
              Spaces.y3,

              /// Skip and continue as guest
              Center(
                child: GestureDetector(
                  onTap: () => controller.navigateToHome(UserType.guest),
                  child: Text(
                    'skip_continue_as_guest'.tr,
                    style: TextStyles.normalBlueBodyText.copyWith(
                      fontSize: Spaces.normSP(11),
                      fontFamily: FontConstants.montserratMedium,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Spaces.y8,

              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: ContactUsButton(
                  text: 'read_terms_conditions'.tr,
                  boldFont: false,
                  onPressed: () {
                    Get.toNamed(Routes.termsConditions);
                  },
                  showIcon: false,
                ),
              ),
              Spaces.y2,
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showIcon;
  final bool boldFont;
  final TextStyle? style;

  const ContactUsButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.showIcon = true,
      this.boldFont = true,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(1.0.w),
          image: const DecorationImage(
              image: AssetImage('assets/images/buttons_bg.png'),
              fit: BoxFit.cover),
          /*gradient: const LinearGradient(
            colors: [
              ColorConstants.appBlue,
              ColorConstants.appBlue,
            ],
          ),*/
          boxShadow: const [
            BoxShadow(
              color: ColorConstants.gray,
              offset: Offset(0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: ColorConstants.unSelectedWidgetColor.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showIcon
                    ? SvgPicture.asset('assets/svgs/ic_headset.svg')
                    : const SizedBox(),
                SizedBox(width: 2.0.w),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: style ??
                      Theme.of(context).textTheme.button!.copyWith(
                            fontFamily: boldFont
                                ? FontConstants.montserratSemiBold
                                : FontConstants.montserratRegular,
                            fontSize: 11.0.sp,
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

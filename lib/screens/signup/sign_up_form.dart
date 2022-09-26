import 'package:fitnessapp/config/form_validators.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/screens/auth_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/drop_down_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_drop_down_checkable_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_phone_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool signUpAsUser;

  const SignUpForm({Key? key, required this.formKey, this.signUpAsUser = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    controller.countries.clear();
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spaces.y2,

          /// profile image selection
          GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) => GestureDetector(
              onTap: () => controller.selectImage(),
              child: Row(
                children: [
                  /// image view
                  ClipOval(
                    child: Container(
                      height: Spaces.normY(10.5),
                      width: Spaces.normY(10.5),
                      decoration: const BoxDecoration(
                        color: ColorConstants.imageBackground,
                      ),
                      child: controller.imageFile == null
                          ? SvgPicture.asset(
                              'assets/svgs/ic_camera_filled.svg',
                              fit: BoxFit.scaleDown,
                            )
                          : Image.file(
                              controller.imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  /// label
                  Spaces.x4,
                  Text(
                    'upload_photo'.tr,
                    style: TextStyles.normalBlueBodyText.copyWith(
                      fontSize: Spaces.normSP(9),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Username field
          FormInputBuilder(
            attribute: 'user_name',
            labelText: 'user_name'.tr,
            maxLength: 30,
            fillColor: ColorConstants.appBlack,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-z0-9_]'))
            ],
            validator: MyFormValidators.textInputRequiredBuilder(
                context: context, errMessage: 'username_required'.tr),
          ),

          /// First name
          FormInputBuilder(
            attribute: 'first_name',
            labelText: 'first_name'.tr,
            maxLength: 30,
            fillColor: ColorConstants.appBlack,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            validator: MyFormValidators.textInputRequiredBuilder(
                context: context, errMessage: 'first_name_required'.tr),
          ),

          /// Last name
          FormInputBuilder(
            attribute: 'last_name',
            labelText: 'last_name'.tr,
            maxLength: 30,
            fillColor: ColorConstants.appBlack,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            validator: MyFormValidators.textInputRequiredBuilder(
                context: context, errMessage: 'last_name_required'.tr),
          ),

          /// Email
          FormInputBuilder(
            attribute: 'email',
            labelText: 'email'.tr,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'email_required'.tr,
              ),
              FormBuilderValidators.email(
                context,
                errorText: 'invalid_email_err'.tr,
              ),
            ]),
          ),

          /// Gender dropDown
          DropdownBuilder(
            attribute: 'gender',
            items: const ['male', 'female'],
            hintText: 'gender'.tr,
            labelText: 'gender'.tr,
          ),

          /// Country dropDown
          GetBuilder<AuthController>(
            id: controller.getCountriesEndPoint,
            builder: (c) => AnimatedContainer(
              duration: 300.milliseconds,
              child: c.countries.isEmpty
                  ? const SizedBox()
                  : DropdownBuilder(
                      attribute: 'country',
                      items: [...c.countries.map((e) => e.name).toList()],
                      hintText: 'country'.tr,
                      labelText: 'country'.tr,
                    ),
            ),
          ),

          FormPhoneBuilder(
            name: 'phone_number',
            labelText: 'phone_number'.tr,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'phone_number_required'.tr,
              ),
              FormBuilderValidators.numeric(
                context,
                errorText: 'invalid_phone'.tr,
              ),
            ]),
          ),

          /// workout dropDown
          if (!signUpAsUser)
            GetBuilder<AuthController>(
              id: controller.getWorkoutTypesEndPoint,
              builder: (c) => AnimatedContainer(
                duration: 300.milliseconds,
                child: c.workoutTypes.isEmpty
                    ? const SizedBox()
                    : MultiSelectFormField(
                        context: context,
                        hintText: 'select'.tr,
                        label: 'workout_program_type'.tr,
                        itemList: {
                          for (var v in c.workoutTypes) v.localizedName: false
                        },
                        questionText: '',
                        validator: (flavours) {
                          c.selectedWorkoutTypes = flavours;
                          return flavours!.isEmpty
                              ? 'workout_err_message'.tr
                              : null;
                        },
                        onSaved: (flavours) {
                          // Logic to save selected flavours in the database
                        },
                      ),
              ),
            ),

          Spaces.y4,

          if (Utils.isRTL())
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'من خلال الاستمرار فإنك موافق على ',
                      style: TextStyles.normalBlackBodyText.copyWith(
                        fontSize: Spaces.normSP(10),
                      ),
                      children: [
                        TextSpan(
                          text: 'الشروط والأحكام ',
                          style: TextStyles.normalBlueBodyText.copyWith(
                            fontSize: Spaces.normSP(10),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(
                                  Routes.termsConditions,
                                  arguments: {'hideHomeButton': true},
                                ),
                        ),
                        TextSpan(
                          text: 'الخاصة بنا',
                          style: TextStyles.normalBlackBodyText.copyWith(
                            fontSize: Spaces.normSP(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'By continuing you choose to agree to our ',
                      style: TextStyles.normalBlackBodyText.copyWith(
                        fontSize: Spaces.normSP(10),
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyles.normalBlueBodyText.copyWith(
                            fontSize: Spaces.normSP(10),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(
                                  Routes.termsConditions,
                                  arguments: {'hideHomeButton': true},
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          Spaces.y4,

          /// Sign up button
          CustomElevatedButton(
            text: 'sign_up'.tr,
            enabled: true,
            onPressed: () => controller.verifyDetailsThenPhone(),
          ),
        ],
      ),
    );
  }
}

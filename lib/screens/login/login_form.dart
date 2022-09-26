import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/login/login_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/password_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final LoginController controller;

  const LoginForm({Key? key, required this.formKey, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          /// Username field
          FormInputBuilder(
            attribute: 'user_name',
            labelText: 'user_name'.tr,
            fillColor: ColorConstants.appBlack,
            textCapitalization: TextCapitalization.none,
            initialValue: controller.userName.value,
            maxLength: 30,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_.]'))
            ],
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(
                  context,
                  errorText: 'username_required'.tr,
                ),
              ],
            ),
          ),

          /// Password field
          PasswordBuilder(
            name: 'password',
            labelText: 'password'.tr,
            initialValue: controller.userName.value,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'enter_password'.tr,
              ),
              FormBuilderValidators.minLength(
                context,
                3,
                errorText: 'pass_length_err'.tr,
              ),
            ]),
          ),
          Spaces.y4,

          /// Login button
          CustomElevatedButton(
            text: 'log_in'.tr,
            onPressed: () {
              formKey.currentState!.save();
              if (formKey.currentState!.validate()) {
                LoginController().login(formKey.currentState!.value);
              }
            },
          ),
        ],
      ),
    );
  }
}

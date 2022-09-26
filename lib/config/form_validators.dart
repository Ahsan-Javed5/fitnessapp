import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class MyFormValidators {
  static FormFieldValidator fieldRequiredValidator(
      String errMessage, BuildContext context) {
    return FormBuilderValidators.required(
      context,
      errorText: errMessage.tr,
    );
  }

  static FormFieldValidator<String> fieldMinLengthValidator(
      String errMessage, int minLength, BuildContext context) {
    return FormBuilderValidators.minLength(
      context,
      minLength,
      errorText: errMessage.tr,
    );
  }

  static FormFieldValidator<String> textInputRequiredBuilder(
      {String errMessage = 'this_field_is_required',
      required BuildContext context}) {
    return FormBuilderValidators.compose([
      fieldRequiredValidator(errMessage, context),
    ]);
  }

  static FormFieldValidator<String?>? passwordValidators(
      {required BuildContext context,
      String requiredErrMessage = 'enter_password',
      String passLengthErrMessage = 'pass_length_err',
      int minLength = 6}) {
    return FormBuilderValidators.compose([
      fieldRequiredValidator(requiredErrMessage, context),
      fieldMinLengthValidator(passLengthErrMessage, minLength, context),
    ]);
  }

  static FormFieldValidator<String?>? confirmPasswordValidators(
      {required BuildContext context,
      required String passwordValue,
      String requiredErrMessage = 'enter_password',
      String passLengthErrMessage = 'pass_length_err',
      int minLength = 6}) {
    return FormBuilderValidators.compose([
      fieldRequiredValidator(requiredErrMessage, context),
      fieldMinLengthValidator(passLengthErrMessage, minLength, context),
      FormBuilderValidators.equal(context, passwordValue,
          errorText: 'password_not_matched_err'.tr),
    ]);
  }
}

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/faqs/faq_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AskQuestionPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AskQuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<FAQController>();

    return CustomScreen(
      hasSearchBar: false,
      backButtonIconPath: 'assets/svgs/ic_close.svg',
      screenTitleTranslated: 'ask_a_question'.tr,
      titleTopMargin: 3,
      hasRightButton: MyHive.getUserType() == UserType.noUser ? false : true,
      rightButton: const HomeButton(),
      titleBottomMargin: 2,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormInputBuilder(
                labelText: 'message_query'.tr,
                attribute: 'question_en',
                minLines: 5,
                maxLines: 5,
                maxLength: 400,
                textCapitalization: TextCapitalization.sentences,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      context,
                      errorText: 'this_field_is_required'.tr,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: false,
                child: FormInputBuilder(
                  labelText: 'message_query'.tr,
                  attribute: 'question_ar',
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 400,
                ),
              ),
              Spaces.y4,
              CustomElevatedButton(
                  text: 'submit'.tr,
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      _controller.askQuestion(_formKey.currentState!.value);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

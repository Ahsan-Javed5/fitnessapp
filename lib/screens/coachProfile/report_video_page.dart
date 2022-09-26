import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'coach_profile_controller.dart';

class ReportVideoPage extends StatelessWidget {
  const ReportVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String query = '';

    return CustomScreen(
      hasSearchBar: false,
      backButtonIconPath: 'assets/svgs/ic_close.svg',
      screenTitleTranslated: 'report'.tr,
      screenDescTranslated: 'please_state_your_issue'.tr,
      titleTopMargin: 3,
      titleBottomMargin: 2,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FormBuilder(
          child: Column(
            children: [
              FormInputBuilder(
                labelText: 'description'.tr,
                attribute: 'query',
                minLines: 5,
                maxLines: 5,
                maxLength: 400,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  query = val.toString();
                },
              ),
              Spaces.y4,
              CustomElevatedButton(
                  text: 'submit'.tr,
                  onPressed: () {
                    //TODO update this
                    var videoId = '2';
                    if (query.isNotEmpty) {
                      CoachProfileController().reportVideo(query, videoId);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

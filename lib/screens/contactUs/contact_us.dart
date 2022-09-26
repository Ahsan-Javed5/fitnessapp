import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/screens/contactUs/contact_us_form.dart';
import 'package:fitnessapp/widgets/actionBars/back_and_right_action_bar.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'contact_us_controller.dart';

class ContactUs extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactUsController());
    controller.getAllCountries();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top action bar
              Spaces.y4,
              const BackAndRightActionBar(),

              Spaces.y2_0,

              /// Main title
              Text(
                'contact_us'.tr,
                style: Get.textTheme.headline1,
              ),

              /// Title desc
              Spaces.y2_0,
              Spaces.y0,
              Text('contact_us_desc'.tr),

              /// Contact us form
              ContactUsForm(
                formKey: formKey,
              ),

              Spaces.y4,
              CustomElevatedButton(
                  text: 'submit'.tr,
                  onPressed: () async {
                    formKey.currentState!.save();
                    if (formKey.currentState!.validate()) {
                      await ContactUsController()
                          .sendContactUsRequest(formKey.currentState!.value);
                      formKey.currentState!.reset();
                    } else {}
                  }),
              Spaces.y4,
            ],
          ),
        ),
      ),
    );
  }
}

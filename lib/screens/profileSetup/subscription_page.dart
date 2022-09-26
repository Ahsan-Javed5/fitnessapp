import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/screens/termsCondition/matrix_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileSetupController controller = Get.find();
    final matrixController = MatrixController();
    matrixController.fetchMatrixData(
      'minimum_subscription_amount',
      supportRTL: false,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'subscription'.tr,
            style: TextStyles.mainScreenHeading,
          ),

          /// Desc
          Spaces.y1_0,
          Text(
            'subscription_note'.tr,
            textAlign: TextAlign.justify,
          ),

          /// Form
          Spaces.y2_0,
          FormBuilder(
            key: controller.subscriptionKey,
            initialValue: const {'subscription_price': 75},
            child: Obx(() => FormInputBuilder(
                  labelText: 'subscription_fee'.tr,
                  attribute: 'subscription_price',
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    ),
                  ],
                  prefixIcon: const Icon(Icons.attach_money_outlined),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: 'this_field_is_required'.tr,
                      ),
                      FormBuilderValidators.min(
                        context,
                        int.tryParse(matrixController.matrixValue.value) ?? 0,
                      ),
                      FormBuilderValidators.numeric(
                        context,
                        errorText: 'invalid_value'.tr,
                      ),
                    ],
                  ),
                )),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: Spaces.normY(4)),
            padding: EdgeInsets.symmetric(
                horizontal: Spaces.normX(2), vertical: Spaces.normY(2.5)),
            decoration: BoxDecoration(
                color: ColorConstants.veryVeryLightGray,
                borderRadius: BorderRadius.circular(Spaces.normX(1))),
            child: Obx(() => Text(
                  Utils.isRTL()
                      ? 'مبلغ الاشتراك الشهري (يجب ألا يقل عن ' +
                          matrixController.matrixValue.value +
                          ' دولار)'
                      : 'Monthly subscription amount (should not be less than \$${matrixController.matrixValue.value})',
                  textAlign: TextAlign.center,
                  style: TextStyles.normalBlueBodyText,
                )),
          ),

          /// Next button
          CustomElevatedButton(
            text: 'next'.tr,
            onPressed: () {
              controller.subscriptionKey.currentState!.save();
              if (controller.subscriptionKey.currentState!.saveAndValidate()) {
                controller.body.addAll(
                    controller.subscriptionKey.currentState?.value ?? {});
                controller.navigateForward();
              }
            },
          ),
          SizedBox(
            height: Spaces.normY(40),
          ),
        ],
      ),
    );
  }
}

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/screens/termsCondition/matrix_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/dialogs/signature_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matrixController = MatrixController();
    matrixController.fetchMatrixData('coach_contract');

    final ProfileSetupController controller = Get.find();
    controller.signatureImageFile = null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Spaces.getHoriPadding(),
            child: Text(
              'terms_and_conditions'.tr,
              style: TextStyles.mainScreenHeading,
            ),
          ),

          /// Desc
          /* Spaces.y1_0,
          Padding(
            padding: Spaces.getHoriPadding(),
            child: Text('contract_desc'.tr),
          ),*/

          /// Contract View
          Spaces.y2_0,
          Container(
            height: Spaces.normY(60),
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: Spaces.normY(2.7),
            ),
            child: Obx(() => matrixController.matrixValue.value.isEmpty
                ? const SizedBox()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Spaces.normX(2)),
                          child: HtmlWidget(
                            matrixController.matrixValue.value,
                          ),
                        ),

                        /// Signature
                        Spaces.y2,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'signature'.tr,
                                textAlign: TextAlign.start,
                              )),
                        ),
                        Spaces.y1_0,
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            useSafeArea: false,
                            builder: (context) => const SignatureDialog(),
                          ),
                          child: Container(
                            height: Spaces.normY(15),
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.dividerColor),
                              borderRadius:
                                  BorderRadius.circular(Spaces.normX(1)),
                            ),
                            child: Center(
                              child: GetBuilder<ProfileSetupController>(
                                id: 'signature_pad',
                                builder: (c) {
                                  return c.signatureImageFile == null
                                      ? Text(
                                          'tap_to_sign'.tr,
                                          textAlign: TextAlign.center,
                                        )
                                      : Image.file(c.signatureImageFile!);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
          ),

          /// Next button
          Spaces.y6,
          Padding(
            padding: Spaces.getHoriPadding(),
            child: CustomElevatedButton(
              text: 'next'.tr,
              onPressed: () {
                if (controller.signatureImageFile == null) {
                  Utils.showSnack(
                      'alert'.tr, 'To continue please accept the contract'.tr);
                  return;
                }
                controller.navigateForward();
              },
            ),
          ),
          Spaces.y6,
        ],
      ),
    );
  }
}

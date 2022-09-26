import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreateChatDialog extends StatelessWidget {
  const CreateChatDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      backgroundColor: ColorConstants.buttonGradientStartColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
              padding: EdgeInsets.only(
                  bottom: Spaces.normY(4), top: Spaces.normY(1)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spaces.normX(2)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  /// Cross button
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                    ),
                  ),

                  /// Title
                  Spaces.y2,
                  Text(
                    'Create 1 to 1 chat',
                    style: TextStyles.subHeadingSemiBold.copyWith(
                      fontSize: Spaces.normSP(15),
                      fontFamily: FontConstants.montserratExtraBold,
                    ),
                  ),

                  FormBuilder(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                          child: FormInputBuilder(
                            labelText: 'Current User'.tr,
                            hintText: 'Username',
                            initialValue: MyHive.getUser()?.firebaseKey ?? '',
                            attribute: 'cu',
                            textCapitalization: TextCapitalization.none,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(
                                  context,
                                  errorText: 'username_required'.tr,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Spaces.normX(5)),
                          child: FormInputBuilder(
                            labelText: 'Target User'.tr,
                            hintText: 'Username',
                            attribute: 'tu',
                            textCapitalization: TextCapitalization.none,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(
                                  context,
                                  errorText: 'username_required'.tr,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spaces.y3,

                  /// Bottom buttons row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            child: FittedBox(child: Text('cancel'.tr)),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: Spaces.normX(8),
                                vertical: Spaces.normY(2),
                              ),
                            ),
                          ),
                        ),
                        Spaces.x3,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.saveAndValidate()) {
                                await Utils.open1to1Chat(
                                    formKey.currentState!.value['cu'],
                                    formKey.currentState!.value['tu'],
                                    context);
                              }
                            },
                            child: FittedBox(child: Text('save'.tr)),
                            style: ElevatedButton.styleFrom(
                              primary: ColorConstants.appBlue,
                              padding: EdgeInsets.symmetric(
                                horizontal: Spaces.normX(7),
                                vertical: Spaces.normY(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

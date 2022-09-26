import 'package:fitnessapp/config/form_validators.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/drop_down_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class BankAccountDetailsPage extends StatelessWidget {
  const BankAccountDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileSetupController>();
    controller.countries.clear();
    controller.getAllCountries();
    final user = MyHive.getUser();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'bank_account_details'.tr,
            style: TextStyles.mainScreenHeading,
          ),

          /// Form
          Spaces.y1_0,
          FormBuilder(
            key: controller.bankDetailsKey,
            child: Column(
              children: [
                FormInputBuilder(
                  labelText: 'full_name'.tr,
                  attribute: 'full_name',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[A-Za-z ]'),
                    ),
                  ],
                  initialValue: user?.getFullName(),
                  validator: MyFormValidators.textInputRequiredBuilder(
                      context: context),
                ),
                GetBuilder<ProfileSetupController>(
                  id: controller.getCountriesEndPoint,
                  builder: (c) => AnimatedContainer(
                    duration: 300.milliseconds,
                    child: c.countries.isEmpty
                        ? const SizedBox()
                        : DropdownBuilder(
                            attribute: 'country_id',
                            items: [...c.countries.map((e) => e.name).toList()],
                            hintText: 'country'.tr,
                            labelText: 'country'.tr,
                            onChanged: (v) {
                              c.toggleSelectedCountry(
                                  v.toString().toLowerCase());
                            },
                          ),
                  ),
                ),
                /* GetBuilder<ProfileSetupController>(
                  id: controller.getAllBanksEndPoint,
                  builder: (c) => AnimatedContainer(
                    duration: 300.milliseconds,
                    child: c.banks.isEmpty
                        ? const SizedBox()
                        : DropdownBuilder(
                            attribute: 'bank_name',
                            items: [...c.banks.map((e) => e.name).toList()],
                            hintText: 'bank_name'.tr,
                            labelText: 'bank_name'.tr,
                          ),
                  ),
                ),*/
                FormInputBuilder(
                  labelText: 'bank_name'.tr,
                  attribute: 'bank_name',
                  initialValue: user?.bankDetails?.fullName,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[A-Za-z0-9 ]'),
                    ),
                  ],
                  validator: MyFormValidators.textInputRequiredBuilder(
                      context: context),
                ),

                /// Swift Code: if country is Qatar then it is not required, other wise it is required.
                Obx(() {
                  return controller.selectedCountryIsQatar.value
                      ? const SizedBox()
                      : FormInputBuilder(
                          labelText: 'bank_swift_code'.tr,
                          attribute: 'bank_swift_code',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[A-Za-z0-9]'),
                            ),
                          ],
                          initialValue: user?.bankDetails?.swiftCode,
                          keyboardType: TextInputType.streetAddress,
                          maxLength: 20,
                        );
                }),
                DropdownBuilder(
                  attribute: 'account_currency',
                  items: Utils.countryCurrencyMap.keys.toList(),
                  hintText: 'account_currency'.tr,
                  labelText: 'account_currency'.tr,
                ),

                /// Account Number: if country is Qatar then it is not required, other wise it is required.
                Obx(() {
                  return controller.selectedCountryIsQatar.value
                      ? const SizedBox()
                      : FormInputBuilder(
                          labelText: 'account_number'.tr,
                          attribute: 'account_number',
                          hintText: '0763xxxxxxxxxxx',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[A-Za-z0-9]'),
                            ),
                          ],
                          initialValue:
                              user?.bankDetails?.accountNumber?.toString(),
                          keyboardType: TextInputType.number,
                          validator: FormBuilderValidators.compose(
                            [
                              if (!controller.selectedCountryIsQatar.value)
                                FormBuilderValidators.required(
                                  context,
                                  errorText: 'This field is required',
                                ),
                            ],
                          ),
                        );
                }),

                /// IBAN: Required for GCC Countries such as Qatar, Saudi Arabia, UAE, Oman, Kuwait and Bahrain.
                Obx(() {
                  return FormInputBuilder(
                    labelText: 'iban_number'.tr,
                    attribute: 'iban_number',
                    initialValue: user?.bankDetails?.ibanNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))
                    ],
                    validator: FormBuilderValidators.compose(
                      [
                        if (controller.showIbanField.value)
                          FormBuilderValidators.required(
                            context,
                            errorText: 'This field is required',
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          /// Next button
          Spaces.y4,
          CustomElevatedButton(
            text: 'next'.tr,
            onPressed: () {
              MyHive.getUser();
              controller.bankDetailsKey.currentState?.save();
              if (controller.bankDetailsKey.currentState?.saveAndValidate() ??
                  false) {
                controller.body.addAll(
                    controller.bankDetailsKey.currentState?.value ?? {});
                controller.navigateForward();
              }
            },
          ),
          Spaces.y6,
        ],
      ),
    );
  }
}

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/contactUs/contact_us_controller.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/drop_down_builder.dart';
import 'package:fitnessapp/widgets/formFieldBuilders/form_input_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ContactUsForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const ContactUsForm({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactUsController());
    controller.countries.clear();

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          /// Name field
          FormInputBuilder(
            attribute: 'name',
            labelText: 'name'.tr,
            textCapitalization: TextCapitalization.words,
            fillColor: ColorConstants.appBlack,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'name_required'.tr,
              ),
            ]),
          ),

          /// Country dropDown
          GetBuilder<ContactUsController>(
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

          /// Phone number field
          FormInputBuilder(
            attribute: 'phone_number',
            labelText: 'phone_number'.tr,
            keyboardType: TextInputType.phone,
            fillColor: ColorConstants.appBlack,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'phone_number_required'.tr,
              ),
            ]),
          ),

          FormInputBuilder(
            attribute: 'email',
            labelText: 'email'.tr,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
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

          /// Message/Query field
          FormInputBuilder(
            attribute: 'message',
            labelText: 'message_query'.tr,
            maxLines: 4,
            minLines: 4,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            fillColor: ColorConstants.appBlack,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                context,
                errorText: 'this_field_is_required'.tr,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

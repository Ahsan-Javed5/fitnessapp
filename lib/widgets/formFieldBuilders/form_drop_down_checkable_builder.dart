import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

/// A Custom [FormField] that restricts invalid data
class MultiSelectFormField extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final Map<String, bool> itemList;

  /// Hint text and the heading in the drop down
  String hintText;

  /// Label of the field
  final String label;

  /// Enter text to show question on the dialog
  final String questionText;

  MultiSelectFormField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.questionText,
    required this.itemList,
    required BuildContext context,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
    List<String>? initialValue,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? [],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<List<String>> state) {
            return GestureDetector(
              /*  onTap: () async => state.didChange(
                await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog(
                        items: itemList,
                      ),
                    ) ??
                    [],
              ),*/

              onTap: () {},
              onTapDown: (details) async {
                state.didChange(
                  await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          0,
                          0,
                        ),
                        items: itemList.keys
                            .map(
                              (e) => PopupMenuItem(
                                height: Spaces.normY(4.5),
                                enabled: false,
                                padding: EdgeInsets.only(
                                    right: Spaces.normX(6),
                                    left: Spaces.normX(3)),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          itemList[e] = !itemList[e]!;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            e,
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Spaces.normSP(12),
                                              fontFamily: FontConstants
                                                  .montserratMedium,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            height: Spaces.normX(3.0),
                                            width: Spaces.normX(3.0),
                                            child: Checkbox(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              splashRadius: 0,
                                              value: itemList[e],
                                              onChanged: (i) {
                                                setState(() {
                                                  itemList[e] = i!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                        elevation: 8.0,
                      ).then((value) {
                        var s = <String>[];
                        itemList.forEach((key, value) {
                          if (value) {
                            s.add(key);
                          }
                        });
                        return s;
                      }) ??
                      [],
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Spaces.y3,

                  Text(
                    label.toUpperCase(),
                    style: Get.textTheme.bodyText2!.copyWith(
                      fontSize: Spaces.normSP(9.5),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: Spaces.normY(2),
                            bottom: Spaces.normY(1.7),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorConstants.appBlack,
                                width: Spaces.normX(0.3),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              (state.value == null || state.value!.isEmpty)

                                  // Show the buttonText as it is
                                  ? Text(
                                      hintText,
                                      style: Get.textTheme.bodyText1!.copyWith(
                                        fontFamily:
                                            FontConstants.montserratRegular,
                                        fontWeight: FontWeight.w300,
                                        color: ColorConstants.bodyTextColor
                                            .withOpacity(0.6),
                                        fontSize: 12.0.sp,
                                      ),
                                    )

                                  // Else show number of selected options
                                  : Text(
                                      state.value!.length == 1
                                          // SINGLE FLAVOR SELECTED
                                          ? '${state.value!.length.toString()} ${Utils.isRTL() ? 'تم تحديد العنصر' : ' item is selected '}'

                                          // MULTIPLE FLAVOR SELECTED
                                          : '${state.value!.length.toString()} ${Utils.isRTL() ? 'العناصر المحددة' : 'items are selected'}',
                                      style: Get.textTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            FontConstants.montserratMedium,
                                      ),
                                    ),

                              const Spacer(),

                              /// Chevron icon
                              SvgPicture.asset(
                                'assets/svgs/ic_chevron_down.svg',
                                fit: BoxFit.scaleDown,
                                width: Spaces.normX(4),
                              ),

                              Spaces.x3,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // If validation fails, display an error
                  state.hasError
                      ? Padding(
                          padding: EdgeInsets.only(top: Spaces.normY(1)),
                          child: Text(
                            state.errorText!,
                            style: TextStyles.normalBlackBodyText.copyWith(
                              fontSize: Spaces.normSP(10.5),
                              color: ColorConstants.redButtonBackground,
                              fontFamily: FontConstants.montserratRegular,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          },
        );
}

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SelectableOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const SelectableOutlinedButton({
    Key? key,
    this.width = double.infinity,
    this.height = -1,
    required this.text,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height == -1 ? 7.5.h : height,
      decoration: selected
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(1.0.w),
              gradient: const LinearGradient(
                colors: [
                  ColorConstants.buttonGradientStartColor,
                  ColorConstants.buttonGradientEndColor
                ],
              ),
              boxShadow: const [
                  BoxShadow(
                    color: ColorConstants.gray,
                    offset: Offset(0, 1.5),
                    blurRadius: 1.5,
                  ),
                ])
          : const BoxDecoration(),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: selected ? Colors.transparent : ColorConstants.appBlack)
        ),
        child: Row(
          children: [
            selected
                ? Radio(
                    value: 1,
                    groupValue: 1,
                    onChanged: null,
                    fillColor: MaterialStateProperty.all(Colors.white),
                  )
                : SizedBox(
                    width: 4.0.w,
                  ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: Get.textTheme.button!.copyWith(
                    color: selected ? Colors.white : ColorConstants.appBlack,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.0.w,
            ),
          ],
        ),
      ),
    );
  }
}

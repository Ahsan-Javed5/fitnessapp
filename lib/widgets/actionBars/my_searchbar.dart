import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MySearchbar extends StatelessWidget {
  final bool animationEnabled;

  const MySearchbar({Key? key, this.animationEnabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _hasFocus = false;
    final textController = TextEditingController();

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return FocusScope(
          child: Focus(
            onFocusChange: (value) {
              setState(
                () {
                  _hasFocus = value;
                },
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: Spaces.normY(5.3),
              margin: EdgeInsetsDirectional.only(
                  end: (_hasFocus && animationEnabled) ? Spaces.normX(10) : 0,
                  start: Spaces.normX(2)),
              child: TextField(
                maxLength: 30,
                controller: textController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  counterText: '',
                  focusColor: Colors.white,
                  hintText: 'search_here'.tr,
                  fillColor: _hasFocus ? Colors.white : Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: Spaces.normX(4),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_search.svg',
                      fit: BoxFit.scaleDown,
                      color: ColorConstants.appBlack,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MySearchbarV4 extends StatefulWidget {
  final Function(String)? onChange;
  final Function? clearBtListener;

  const MySearchbarV4({Key? key, this.onChange, this.clearBtListener})
      : super(key: key);

  @override
  _MySearchbarV4State createState() => _MySearchbarV4State();
}

class _MySearchbarV4State extends State<MySearchbarV4> {
  bool _hasFocus = false;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          height: Spaces.normY(5.5),
          margin: EdgeInsets.symmetric(horizontal: Spaces.normX(2)),
          padding: EdgeInsets.symmetric(vertical: Spaces.normY(1)),
          decoration: BoxDecoration(
            //color: _hasFocus ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(Spaces.normX(1)),
            border: Border.all(
              color: ColorConstants.appBlack,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spaces.x2,
              SizedBox(child: SvgPicture.asset('assets/svgs/ic_search.svg')),
              Expanded(
                child: Focus(
                  onFocusChange: (value) => setState(
                    () {
                      _hasFocus = value;
                    },
                  ),
                  child: TextField(
                    onChanged: widget.onChange,
                    maxLength: 30,
                    controller: textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      focusColor: Colors.black54,
                      hintText: 'search_here'.tr,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: Spaces.normX(4),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _hasFocus,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Spaces.normX(1)),
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      'assets/svgs/ic_cross.svg',
                      height: Spaces.normY(2),
                    ),
                    onTap: () {
                      textController.clear();
                      widget.clearBtListener!();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              Spaces.x2,
            ],
          )),
    );
  }
}

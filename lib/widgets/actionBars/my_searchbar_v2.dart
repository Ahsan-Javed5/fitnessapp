import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MySearchbarV2 extends StatefulWidget {
  final VoidCallback? filterListener;
  const MySearchbarV2({Key? key, this.filterListener}) : super(key: key);

  @override
  _MySearchbarV2State createState() => _MySearchbarV2State();
}

class _MySearchbarV2State extends State<MySearchbarV2> {
  bool _hasFocus = false;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spaces.normY(5),
      margin: EdgeInsets.symmetric(horizontal: Spaces.normX(2)),
      padding: EdgeInsets.symmetric(vertical: Spaces.normY(1)),
      decoration: BoxDecoration(
        color: _hasFocus ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(Spaces.normX(1)),
        border: Border.all(
          color: _hasFocus ? Colors.transparent : ColorConstants.appBlack,
          width: 1.0,
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        fit: StackFit.expand,
        children: [
          /// Search Icon
          AnimatedPositionedDirectional(
            top: 0,
            bottom: 0,
            start: _hasFocus ? Spaces.normX(60) : Spaces.normX(2.5),
            child: SvgPicture.asset('assets/svgs/ic_search.svg'),
            duration: const Duration(milliseconds: 300),
          ),

          /// Search bar
          AnimatedPositionedDirectional(
              top: 0,
              bottom: 0,
              start: _hasFocus ? 0 : Spaces.normX(7),
              child: FocusScope(
                child: Focus(
                  onFocusChange: (value) {
                    setState(
                      () {
                        _hasFocus = value;
                      },
                    );
                  },
                  child: SizedBox(
                    width: Spaces.normX(70),
                    child: TextField(
                      maxLength: 30,
                      controller: textController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        focusColor: Colors.white,
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
              ),
              duration: const Duration(milliseconds: 500)),

          /// Filter icon
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: Spaces.normX(2.5),
            child: GestureDetector(
              onTap: widget.filterListener,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _hasFocus ? 0 : 1,
                child: _hasFocus
                    ? const SizedBox()
                    : SvgPicture.asset('assets/svgs/ic_filter.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

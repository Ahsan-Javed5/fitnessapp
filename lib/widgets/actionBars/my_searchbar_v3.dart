import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MySearchbarV3 extends StatefulWidget {
  final VoidCallback? filterListener;
  final Function(String)? onChange;
  final Function(bool)? focusListener;
  final bool hasFilterIcon;
  final TextEditingController? textEditingController;

  const MySearchbarV3(
      {Key? key,
      this.filterListener,
      this.onChange,
      this.textEditingController,
      this.focusListener,
      this.hasFilterIcon = true})
      : super(key: key);

  @override
  _MySearchbarV3State createState() => _MySearchbarV3State();
}

class _MySearchbarV3State extends State<MySearchbarV3> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spaces.normY(5),
      margin: EdgeInsets.symmetric(horizontal: Spaces.normX(2)),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        fit: StackFit.expand,
        children: [
          /// Filter icon
          if (widget.hasFilterIcon)
            PositionedDirectional(
              top: 0,
              bottom: 0,
              end: 0,
              child: GestureDetector(
                onTap: widget.filterListener,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _hasFocus ? 0 : 1,
                  child: _hasFocus
                      ? const SizedBox()
                      : SvgPicture.asset('assets/svgs/ic_filter.svg'),
                ),
              ),
            ),

          /// Search bar and icon
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: 0,
            child: AnimatedContainer(
              duration: 300.milliseconds,
              width: _hasFocus ? Spaces.normX(87) : Spaces.normX(71),
              decoration: BoxDecoration(
                color: _hasFocus ? Colors.white : ColorConstants.whiteLevel2,
                borderRadius: BorderRadius.circular(Spaces.normX(1)),
              ),
              child: Stack(
                children: [
                  /// Search bar
                  AnimatedPositionedDirectional(
                      top: 0,
                      bottom: 0,
                      start: _hasFocus ? 0 : Spaces.normX(8),
                      child: Center(
                        child: FocusScope(
                          child: Focus(
                            onFocusChange: (value) => setState(
                              () {
                                if (widget.focusListener != null) {
                                  widget.focusListener!(value);
                                }
                                _hasFocus = value;
                              },
                            ),
                            child: SizedBox(
                              width: Spaces.normX(58),
                              child: TextField(
                                maxLength: 30,
                                onChanged: widget.onChange,
                                controller: widget.textEditingController,
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
                      ),
                      duration: const Duration(milliseconds: 500)),

                  /// Search Icon
                  AnimatedPositionedDirectional(
                    top: 0,
                    bottom: 0,
                    start: _hasFocus ? Spaces.normX(70) : Spaces.normX(3),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_search.svg',
                      color: _hasFocus
                          ? ColorConstants.appBlack
                          : ColorConstants.bodyTextColor,
                    ),
                    duration: const Duration(milliseconds: 400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

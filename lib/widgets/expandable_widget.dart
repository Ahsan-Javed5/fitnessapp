import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final String desc;

  const ExpandableCard({Key? key, required this.title, required this.desc})
      : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Spaces.normX(1.5)),
          child: GestureDetector(
            onTap: () => setState(() {
              isExpanded = !isExpanded;
            }),
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.veryVeryLightGray,
                border: Border.all(color: ColorConstants.whiteColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: widget.title.contains('<')
                        ? Padding(
                            padding: EdgeInsets.all(Spaces.normX(4)),
                            child: HtmlWidget(
                              widget.title,
                              textStyle:
                                  TextStyles.normalBlackBodyText.copyWith(
                                color: ColorConstants.appBlack,
                                fontFamily: FontConstants.montserratMedium,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(Spaces.normX(4)),
                            child: Text(
                              widget.title,
                              maxLines: 4,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.subHeadingSemiBold.copyWith(
                                  color: ColorConstants.appBlack,
                                  fontSize: Spaces.normSP(11),
                                  fontFamily: FontConstants.montserratMedium,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                  ),
                  SvgPicture.asset(
                    !isExpanded
                        ? 'assets/svgs/ic_chevron_down.svg'
                        : 'assets/svgs/ic_chevron_up.svg',
                    fit: BoxFit.scaleDown,
                    height: Spaces.normY(1),
                    width: Spaces.normY(1),
                  ),
                  Spaces.x2,
                ],
              ),
            ),
          ),
        ),
        isExpanded ? Spaces.y1 : const SizedBox(),
        isExpanded
            ? ClipRRect(
                borderRadius: BorderRadius.circular(Spaces.normX(1.5)),
                child: AnimatedContainer(
                  width: double.infinity,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorConstants.grayLight.withOpacity(0.6),
                        width: 1),
                    color: ColorConstants.whiteColor,
                  ),
                  duration: 400.milliseconds,
                  child: (widget.desc.contains('<'))
                      ? HtmlWidget(
                          widget.desc,
                          textStyle: TextStyles.normalBlackBodyText.copyWith(
                            color: ColorConstants.appBlack,
                            fontFamily: FontConstants.montserratRegular,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(Spaces.normX(3)),
                          child: Text(
                            widget.desc,
                            textAlign: TextAlign.justify,
                            style: TextStyles.normalGrayBodyText.copyWith(
                              fontSize: Spaces.normSP(11),
                              color: ColorConstants.appBlack,
                            ),
                          ),
                        ),
                ),
              )
            : Spaces.y2,
        isExpanded ? Spaces.y2 : const SizedBox(),
      ],
    );
  }
}

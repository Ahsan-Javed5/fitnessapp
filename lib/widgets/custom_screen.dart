import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/// --------------- What's included in this screen-------------------------////
/// This screen also has a app background gradient by default
/// This screen [hasBackButton] default value is true and you can also provide [backHandler]
/// This screen [hasRightButton] default false is true and you can also provide [rightButtonHandler]
/// This screen [hasSearchBar] default value is true
/// [screenTitleTranslated] if provided will show a screen heading with style [TextStyles.mainScreenHeading]
/// [screenDescTranslated] if provided will show a screen heading with style [TextTheme.textBody2]
/// [includeHeaderPadding] if set to true will add padding horizontally
/// You can optionally provide a [floatingActionButton] to this screen
/// You can also enable and disable animations of the [searchBar] by using [animatedSearchBar]
/// You can include or exclude top or bottom padding using [includeVerticalMargin]
///
/// use [child] when you want to provide custom scroll or other flex widgets
/// use [children] to provide multiple children, these will be scrolled by parent
/// created by Awais Abbas
class CustomScreen extends StatelessWidget {
  final List<Widget>? children;
  final bool includeHeaderPadding;
  final Widget? floatingActionButton;
  final bool hasBackButton;
  final bool hasRightButton;
  final bool hasSearchBar;
  final VoidCallback? backHandler;
  final Function? rightButtonHandler;
  final Widget? rightButton;
  final bool animatedSearchBar;
  final String? screenTitleTranslated;
  final String? screenDescTranslated;
  final double titleTopMargin;
  final double titleBottomMargin;
  final bool includeVerticalMargin;
  final String? backButtonIconPath;
  final bool includeBodyPadding;
  final Widget? child;
  final Function(String)? onSearchBarTextChange;
  final Function? onSearchbarClearText;

  const CustomScreen({
    Key? key,
    this.children,
    this.includeHeaderPadding = true,
    this.floatingActionButton,
    this.hasBackButton = true,
    this.hasRightButton = false,
    this.hasSearchBar = true,
    this.backHandler,
    this.rightButton,
    this.animatedSearchBar = true,
    this.includeVerticalMargin = true,
    this.rightButtonHandler,
    this.screenTitleTranslated,
    this.titleTopMargin = 0,
    this.titleBottomMargin = 0,
    this.screenDescTranslated,
    this.backButtonIconPath,
    this.includeBodyPadding = true,
    this.child,
    this.onSearchBarTextChange,
    this.onSearchbarClearText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Background gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            ColorConstants.whiteColor,
            ColorConstants.whiteColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: Get.locale!.languageCode == 'ar'
              ? FloatingActionButtonLocation.startFloat
              : FloatingActionButtonLocation.endFloat,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spaces.y1,

              /// Top Bar Construction site
              Padding(
                padding: includeHeaderPadding
                    ? Spaces.getHoriPadding()
                    : EdgeInsets.zero,
                child: Row(
                  children: [
                    /// Back button
                    hasBackButton
                        ? SizedBox(
                            width: Spaces.normX(8),
                            child: IconButton(
                              onPressed: backHandler ?? () => Get.back(),
                              icon: SvgPicture.asset(
                                backButtonIconPath ??
                                    'assets/svgs/ic_arrow.svg',
                                matchTextDirection: true,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          )
                        : const SizedBox(),

                    /// Search bar
                    hasSearchBar
                        ? MySearchbarV4(
                            onChange: onSearchBarTextChange,
                            clearBtListener: onSearchbarClearText,
                          )
                        : const Spacer(),

                    /// Right Button
                    hasRightButton ? rightButton! : const SizedBox(),
                  ],
                ),
              ),

              /// Construct screen title if it is available
              SizedBox(
                height: Spaces.normY(titleTopMargin),
              ),
              if (screenTitleTranslated != null)
                Padding(
                  padding: includeHeaderPadding
                      ? Spaces.getHoriPadding()
                      : EdgeInsets.zero,
                  child: Text(
                    screenTitleTranslated!.isEmpty
                        ? 'No Title Found'
                        : screenTitleTranslated!,
                    style: TextStyles.mainScreenHeading,
                  ),
                ),
              SizedBox(
                height: Spaces.normY(titleBottomMargin),
              ),

              /// Construct screen desc
              if (screenDescTranslated != null)
                Padding(
                  padding: includeHeaderPadding
                      ? Spaces.getHoriPadding()
                      : EdgeInsets.zero,
                  child: Text(screenDescTranslated!),
                ),

              /// Body Construction Site
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Padding(
                    padding: includeBodyPadding
                        ? Spaces.getHoriPadding()
                        : EdgeInsets.zero,
                    child: child ??
                        ListView(
                          children: children!,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

library flutter_zoom_drawer;

import 'dart:math' show pi;

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoomDrawerController {
  /// callback function to open the drawer
  Function? open;

  /// callback function to close the drawer
  Function? close;

  /// callback function to toggle the drawer
  Function? toggle;

  /// callback function to determine the status of the drawer
  Function? isOpen;

  /// Drawer state notifier
  /// opening, closing, open, closed
  ValueNotifier<DrawerState>? stateNotifier;
}

class ZoomDrawer extends StatefulWidget {
  ZoomDrawer({
    this.style = DrawerStyle.DefaultStyle,
    this.controller,
    required this.menuScreen,
    required this.mainScreen,
    this.mainScreenScale = 0.3,
    this.slideWidth = 275.0,
    this.borderRadius = 25.0,
    this.angle = -12.0,
    this.backgroundColor = const Color(0xffffffff),
    this.showShadow = false,
    this.openCurve,
    this.closeCurve,
    this.duration,
    this.disableGesture = false,
    this.isRtl,
    this.clipMainScreen = true,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  /// Layout style
  final DrawerStyle style;

  /// controller to have access to the open/close/toggle function of the drawer
  final ZoomDrawerController? controller;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  /// MainScreen scale factor
  final double mainScreenScale;

  /// Sliding width of the drawer - defaults to 275.0
  final double slideWidth;

  /// Border radius of the slided content - defaults to 16.0
  final double borderRadius;

  /// Rotation angle of the drawer - defaults to -12.0
  final double angle;

  /// Background color of the drawer shadows - defaults to white
  final Color backgroundColor;

  /// Boolean, whether to show the drawer shadows - defaults to false
  final bool showShadow;

  /// Drawer slide out curve
  final Curve? openCurve;

  /// Drawer slide in curve
  final Curve? closeCurve;

  /// Drawer Duration
  final Duration? duration;

  /// Disable swipe gesture
  final bool disableGesture;

  /// display the drawer in RTL
  final bool? isRtl;

  /// determine whether to clip the main screen
  final bool clipMainScreen;

  @override
  _ZoomDrawerState createState() => _ZoomDrawerState();

  /// static function to provide the drawer state
  static _ZoomDrawerState? of(BuildContext context) {
    return context.findAncestorStateOfType<State<ZoomDrawer>>()
        as _ZoomDrawerState?;
  }

  /// Languages that are Right to Left
  static List<String> RTL_LANGUAGES = ['ar', 'ur', 'he', 'dv', 'fa'];

  /// Static function to determine the device text direction RTL/LTR
  static bool isRTL() {
    /// Device language
    final locale = _getLanguageCode();

    return RTL_LANGUAGES.contains(locale);
  }

  static String? _getLanguageCode() {
    try {
      return Get.locale?.languageCode.toLowerCase();
    } catch (e) {
      return null;
    }
  }
}

class _ZoomDrawerState extends State<ZoomDrawer>
    with SingleTickerProviderStateMixin {
  final Curve _scaleDownCurve = const Interval(0.0, 0.3, curve: Curves.easeOut);
  final Curve _scaleUpCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  final Curve _slideOutCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  final Curve _slideInCurve =
      const Interval(0.0, 1.0, curve: Curves.easeOut); // Curves.bounceOut

  /// check the slide direction
  late int _rtlSlide;

  late bool _rtl;

  AnimationController? _animationController;
  DrawerState _state = DrawerState.closed;

  double get _percentOpen => _animationController!.value;

  /// Open drawer
  open() {
    _animationController!.forward();
  }

  /// Close drawer
  close() {
    _animationController!.reverse();
  }

  AnimationController? get animationController => _animationController;

  /// Toggle drawer
  toggle() {
    if (_state == DrawerState.open) {
      close();
    } else if (_state == DrawerState.closed) {
      open();
    }
  }

  /// check whether drawer is open
  bool isOpen() =>
      _state == DrawerState.open /* || _state == DrawerState.opening*/;

  /// Drawer state
  ValueNotifier<DrawerState>? stateNotifier;

  @override
  void initState() {
    super.initState();

    stateNotifier = ValueNotifier(_state);

    /// Initialize the animations controller
    /// add status listener to update the menuStatus
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration is Duration
          ? widget.duration
          : const Duration(milliseconds: 300),
    )..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = DrawerState.opening;
            _updateStatusNotifier();
            break;
          case AnimationStatus.reverse:
            _state = DrawerState.closing;
            _updateStatusNotifier();
            break;
          case AnimationStatus.completed:
            _state = DrawerState.open;
            _updateStatusNotifier();
            break;
          case AnimationStatus.dismissed:
            _state = DrawerState.closed;
            _updateStatusNotifier();
            break;
        }
      });

    /// assign controller function to the widget methods
    if (widget.controller != null) {
      widget.controller!.open = open;
      widget.controller!.close = close;
      widget.controller!.toggle = toggle;
      widget.controller!.isOpen = isOpen;
      widget.controller!.stateNotifier = stateNotifier;
    }

    _rtl = widget.isRtl ?? ZoomDrawer.isRTL();
    _rtlSlide = _rtl ? -1 : 1;
  }

  @override
  void didUpdateWidget(covariant ZoomDrawer oldWidget) {
    if (oldWidget.isRtl != widget.isRtl) {
      _rtl = widget.isRtl ?? ZoomDrawer.isRTL();
      _rtlSlide = _rtl ? -1 : 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  _updateStatusNotifier() {
    stateNotifier!.value = _state;
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  /// Build the widget based on the animations value
  ///
  /// * [container] is the widget to be displayed
  ///
  /// * [angle] is the the Z rotation angle
  ///
  /// * [scale] is a string to help identify this animations during
  ///   debugging (used by [toString]).
  ///
  /// * [slide] is the sliding amount of the drawer
  ///
  Widget _zoomAndSlideContent(Widget? container,
      {double? angle, double? scale, double slide = 0}) {
    var slidePercent, scalePercent;

    /// determine current slide percent based on the MenuStatus
    switch (_state) {
      case DrawerState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case DrawerState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case DrawerState.opening:
        slidePercent =
            (widget.openCurve ?? _slideOutCurve).transform(_percentOpen);
        scalePercent = _scaleDownCurve.transform(_percentOpen);
        break;
      case DrawerState.closing:
        slidePercent =
            (widget.closeCurve ?? _slideInCurve).transform(_percentOpen);
        scalePercent = _scaleUpCurve.transform(_percentOpen);
        break;
    }

    /// calculated sliding amount based on the RTL and animations value
    final slideAmount = (widget.slideWidth - slide) * slidePercent * _rtlSlide;

    /// calculated scale amount based on the provided scale and animations value
    final contentScale = (scale ?? 1) - (0.43 * scalePercent);

    /// calculated radius based on the provided radius and animations value
    final cornerRadius = widget.borderRadius * _percentOpen;

    /// calculated rotation amount based on the provided angle and animations value
    final rotationAngle =
        (((angle ?? widget.angle) * pi * _rtlSlide) / 180) * _percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..rotateZ(rotationAngle)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: widget.clipMainScreen
          ? ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: container,
            )
          : container,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disableGesture) return renderLayout();

    return GestureDetector(
      /// Detecting the slide amount to close the drawer in RTL & LTR
      onPanUpdate: (details) {
        if (_state == DrawerState.open &&
            ((details.delta.dx < -6 && !_rtl) ||
                (details.delta.dx < 6 && _rtl))) {
          toggle();
        }
      },
      child: renderLayout(),
    );
  }

  Widget renderLayout() {
    switch (widget.style) {
      case DrawerStyle.Style1:
        return renderStyle1();
      default:
        return renderDefault();
    }
  }

  Widget renderDefault() {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        double slide = widget.slideWidth * _percentOpen * _rtlSlide;
        double scale = 1 - (_percentOpen * widget.mainScreenScale);
        final cornerRadius = widget.borderRadius * _percentOpen;

        return Stack(
          children: [
            widget.menuScreen,
            Transform(
              transform: Matrix4.identity()
                ..translate(slide)
                ..scale(scale),
              alignment: Alignment.center,
              child: widget.clipMainScreen
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(cornerRadius),
                      child: widget.mainScreen,
                    )
                  : widget.mainScreen,
            ),
          ],
        );
      },
    );
  }

  Widget renderStyle1() {
    final slidePercent = _rtl ? MediaQuery.of(context).size.width * .1 : 15.0;
    return Stack(
      children: [
        widget.menuScreen,
        if (widget.showShadow) ...[
          /// Displaying the first shadow
          AnimatedBuilder(
            animation: _animationController!,
            builder: (_, w) => _zoomAndSlideContent(
              w,
              angle: (widget.angle == 0.0) ? 0.0 : widget.angle - 8,
              scale: .82,
              slide: slidePercent * 2,
            ),
            child: Container(
              //TODO fix this
              // color: ColorConstants.grayLevel2,
              color: ColorConstants.bodyTextColor,
            ),
          ),

          /// Displaying the second shadow
          AnimatedBuilder(
            animation: _animationController!,
            builder: (_, w) => _zoomAndSlideContent(
              w,
              angle: (widget.angle == 0.0) ? 0.0 : widget.angle - 4.0,
              scale: .88,
              slide: slidePercent,
            ),
            child: Container(
              //TODO To be fixed
              // color: ColorConstants.thatch,
              color: ColorConstants.brownLevel1,
            ),
          )
        ],

        /// Displaying the main screen
        AnimatedBuilder(
          animation: _animationController!,
          builder: (_, w) => _zoomAndSlideContent(w),
          child: GestureDetector(
            child: widget.mainScreen,
            onTap: () {
              if (_state == DrawerState.open) {
                toggle();
              }
            },
          ),
        ),
      ],
    );
  }
}

/// Drawer State enum
enum DrawerState { opening, closing, open, closed }

enum DrawerStyle {
  DefaultStyle,
  Style1,
  Style2,
  Style3,
  Style4,
  Style5,
  Style6,
  Style7
}

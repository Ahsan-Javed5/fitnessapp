import 'dart:developer';

import 'package:flutter/material.dart';

class SwipeMessage extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final IconData iconOnRightSwipe;
  final Widget? rightSwipeWidget;
  final IconData iconOnLeftSwipe;
  final Widget? leftSwipeWidget;
  final double iconSize;
  final Color? iconColor;
  final double offsetDx;
  final VoidCallback? onRightSwipe;
  final VoidCallback? onLeftSwipe;

  const SwipeMessage({
    Key? key,
    required this.child,
    this.onRightSwipe,
    this.onLeftSwipe,
    this.iconOnRightSwipe = Icons.reply,
    this.rightSwipeWidget,
    this.iconOnLeftSwipe = Icons.reply,
    this.leftSwipeWidget,
    this.iconSize = 26.0,
    this.iconColor,
    this.animationDuration = const Duration(milliseconds: 150),
    this.offsetDx = 0.3,
  }) : super(key: key);

  @override
  _SwipeMessageState createState() => _SwipeMessageState();
}

class _SwipeMessageState extends State<SwipeMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _leftIconAnimation;
  late Animation<double> _rightIconAnimation;
  late VoidCallback _onSwipeLeft;
  late VoidCallback _onSwipeRight;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    _leftIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _rightIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _onSwipeLeft = widget.onLeftSwipe ??
        () {
          log('Left Swipe Not Provided');
        };

    _onSwipeRight = widget.onRightSwipe ??
        () {
          log('Right Swipe Not Provided');
        };
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation({required bool onRight}) {
    _animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(onRight ? widget.offsetDx : -widget.offsetDx, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    if (onRight) {
      _leftIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    } else {
      _rightIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller),
      );
    }
    _controller.forward().whenComplete(() {
      _controller.reverse().whenComplete(() {
        if (onRight) {
          _leftIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));
          _onSwipeRight();
        } else {
          _rightIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));

          _onSwipeLeft();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 1 && widget.onRightSwipe != null) {
          _runAnimation(onRight: true);
        }
        if (details.delta.dx < -1 && widget.onLeftSwipe != null) {
          _runAnimation(onRight: false);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _leftIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.rightSwipeWidget ??
                    Icon(
                      widget.iconOnRightSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
              AnimatedOpacity(
                opacity: _rightIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: widget.leftSwipeWidget ??
                    Icon(
                      widget.iconOnLeftSwipe,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? Theme.of(context).iconTheme.color,
                    ),
              ),
            ],
          ),
          SlideTransition(
            position: _animation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Thread.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:sizer/sizer.dart';

class ThreadItem extends StatefulWidget {
  final int _position;
  final String _threadId;
  final String _currentUserId;
  final double _lastActivityTime;
  final bool isSelected;
  final Function _callBackFunctionForClick;
  final Function _callBackFunctionLatestActivityValue;

  const ThreadItem(
      this._position,
      this._threadId,
      this._currentUserId,
      this._lastActivityTime,
      this.isSelected,
      this._callBackFunctionForClick,
      this._callBackFunctionLatestActivityValue,
      {Key? key})
      : super(key: key);

  @override
  _ThreadItemState createState() => _ThreadItemState();
}

class _ThreadItemState extends State<ThreadItem> {
  _ThreadItemState();

  Thread? _thread;
  late final PausableTimer timer;
  StreamSubscription? _subscription;
  String typingIndication = '';

  @override
  void initState() {
    super.initState();
    ThreadsController.fetchThreadWithThreadIdLiveRef(
            widget._threadId, widget._currentUserId, _updateTheChanges)
        .then((StreamSubscription s) {
      return _subscription = s;
    });

    ///Using timer to limit the calls to refresh the screens
    ///there are some scenarios in which program tries to call this method hundred of time
    ///so i am using timer
    ///Logic: when program want to call setState start a timer for 200 ms
    ///if during these 200 ms a new call comes reset the timer
    ///and keep doing this when a delay occurs more than 200
    ///don't increase the timer as this will ruin the UX
    timer = PausableTimer(const Duration(milliseconds: 200), () {
      setState(() {
        if (_thread?.latestActivityTime != widget._lastActivityTime) {
          widget._callBackFunctionLatestActivityValue(
              widget._threadId, _thread?.latestActivityTime);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Only show threads that has at least one message
    return (_thread?.messages?.isNotEmpty ?? false)
        ? Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.containerBorderColor),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: TextButton(
              onPressed: () =>
                  widget._callBackFunctionForClick(widget._position, _thread),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 2.0.w,
                    ),

                    ///Image view
                    if (_thread != null)
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ///profile picture
                          ClipOval(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 17.w,
                                  width: 17.w,
                                  child: CustomNetworkImage(
                                    imageUrl: '${_thread?.displayPictureUrl}',
                                    fit: BoxFit.cover,
                                    useDefaultBaseUrl: !(_thread
                                            ?.displayPictureUrl
                                            ?.contains('http') ??
                                        false),
                                  ),
                                ),
                                if (widget.isSelected)
                                  Container(
                                    height: 17.w,
                                    width: 17.w,
                                    color:
                                        ColorConstants.appBlue.withOpacity(0.3),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 2,
                                        sigmaY: 2,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/ic_check_mark_small.svg',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          ///Online indicator
                          if (_thread?.onlineIndicator != null)
                            Container(
                              margin: EdgeInsets.only(bottom: 1.0.h),
                              height: 1.5.h,
                              width: 1.5.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                    width: 0.2.h, color: Colors.white),
                              ),
                            ),
                        ],
                      ),

                    SizedBox(
                      width: 3.0.w,
                    ),

                    ///Thread name, and last message view
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            _thread?.displayName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorConstants.appBlack,
                              fontSize: 13.5.sp,
                              fontFamily: FontConstants.montserratMedium,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            _thread?.lastMessage ?? '...',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorConstants.bodyTextColor,
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 1.w),

                    ///time view and unread message count
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _thread?.prettyTime ?? '',
                          style: TextStyle(
                            color: ColorConstants.appBlack,
                            fontSize: 9.0.sp,
                            fontFamily: FontConstants.montserratRegular,
                          ),
                        ),
                        _thread != null
                            ? _thread!.unreadCount > 0
                                ? Container(
                                    height: 3.0.h,
                                    width: 3.0.h,
                                    margin: EdgeInsets.only(top: 1.h),
                                    child: Center(
                                      child: Text(
                                        _thread!.unreadCount.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorConstants.redButtonBackground,
                                    ),
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                      ],
                    ),

                    SizedBox(
                      width: 2.0.w,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  _updateTheChanges(Thread thread) {
    if (!mounted) return;
    _thread = thread;
    _thread?.addListener(() {
      if (mounted) {
        timer.reset();
        timer.start();
      }
    });
  }

  @override
  void deactivate() {
    _subscription?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _thread?.unSubscribe();
    _thread?.removeListener(() {});
    super.dispose();
  }
}

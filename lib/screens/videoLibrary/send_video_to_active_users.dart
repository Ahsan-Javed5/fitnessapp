import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/models/subscription.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/chat/controllers/chat_api_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_controller.dart';
import 'package:fitnessapp/widgets/custom_network_image.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../config/space_values.dart';

class SendVideoToActiveUsers extends StatelessWidget {
  const SendVideoToActiveUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subCon = Get.put(SubscriptionController());
    subCon.getSubscriptions();
    RxList<Video> selectedPrivateVideos = <Video>[].obs;
    selectedPrivateVideos = Get.arguments?['videosToSend'] as RxList<Video>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.transparent,
        elevation: 0,
        leadingWidth: 17.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Center(
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                  minimumSize: Size(18.0.w, 4.0.h),
                  padding: const EdgeInsetsDirectional.only(end: 0)),
              child: Text(
                'Cancel',
                style: Get.textTheme.button!.copyWith(
                  color: ColorConstants.appBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                  fontFamily: FontConstants.montserratRegular,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 0.5.w),
            child: Center(
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                    minimumSize: Size(18.0.w, 4.0.h),
                    padding: const EdgeInsetsDirectional.only(end: 0)),
                child: Text(
                  'Done',
                  style: Get.textTheme.button!.copyWith(
                    color: ColorConstants.appBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    fontFamily: FontConstants.montserratRegular,
                  ),
                ),
              ),
            ),
          )
        ],
        title: Text(
          'Send To',
          style: Get.textTheme.button!.copyWith(
            color: ColorConstants.appBlack,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            fontFamily: FontConstants.montserratExtraBold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActiveUserSearchFiled(
              onChanged: (value) {},
            ),
            Spaces.y4,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACTIVE SUBSCRIBERS',
                style: Get.textTheme.button!.copyWith(
                  color: ColorConstants.gray,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  fontSize: 8.sp,
                  fontFamily: FontConstants.montserratRegular,
                ),
              ),
            ),
            Spaces.y4,
            Expanded(
              child: GetBuilder<SubscriptionController>(
                id: subCon.getActiveSubs,
                builder: (_) {
                  return subCon.availSub == 0
                      ? const Center(
                          child: EmptyView(
                            customMessage: 'No Active User',
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: subCon.tempActiveSubs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return ActiveSubscriptionUserItem(
                              subUser: subCon.tempActiveSubs[index],
                              selectedPrivateVideos: selectedPrivateVideos,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Spaces.y4,
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SendVideoButton extends StatelessWidget {
  final Subscription subUser;
  final RxList<Video> selectedPrivateVideos;
  const SendVideoButton(
      {Key? key, required this.subUser, required this.selectedPrivateVideos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.isRegistered<ChatApiController>()
        ? Get.find<ChatApiController>()
        : Get.put(ChatApiController());
    RxBool isMessageSend = false.obs;
    RxBool sending = false.obs;
    return Transform.scale(
      scale: 0.7,
      child: Obx(
        () => OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorConstants.sendBtnColor,
            padding: EdgeInsets.zero,
            fixedSize: Size(20.w, 10),
            side: const BorderSide(
              width: 1,
              color: ColorConstants.sendBtnBorderColor,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: isMessageSend.isTrue
              ? null
              : () {
                  sending.value = true;
                  chatController.sendVideoChatMessage(
                      items: selectedPrivateVideos,
                      subUser: subUser,
                      onError: () {
                        isMessageSend.value = false;
                        sending.value = false;
                      },
                      onMessageSent: () {
                        sending.value = false;
                        isMessageSend.value = true;
                      });
                },
          child: Center(
            child: FittedBox(
              child: sending.isTrue
                  ? Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(ColorConstants.gray),
                      ),
                    )
                  : Text(
                      isMessageSend.isTrue ? 'SENT' : 'SEND',
                      style: Get.textTheme.button!.copyWith(
                        color: isMessageSend.isTrue
                            ? ColorConstants.gray
                            : ColorConstants.appBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        letterSpacing: 0.5,
                        fontFamily: FontConstants.montserratMedium,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveUserSearchFiled extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? textEditingController;
  const ActiveUserSearchFiled({
    Key? key,
    required this.onChanged,
    this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'search_here'.tr,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: Spaces.normX(4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusColor: ColorConstants.whiteColor,
          filled: false,
          fillColor: ColorConstants.whiteColor,
          hintStyle: Get.theme.textTheme.caption!.copyWith(
              color: ColorConstants.appBlack,
              fontFamily: FontConstants.montserratMedium,
              fontSize: 12.sp),
          prefixIcon: Icon(
            Icons.search,
            size: 4.h,
            color: ColorConstants.appBlack,
          ),
        ),
      ),
    );
  }
}

class ActiveSubscriptionUserItem extends StatelessWidget {
  final Subscription subUser;
  final RxList<Video> selectedPrivateVideos;
  const ActiveSubscriptionUserItem(
      {Key? key, required this.subUser, required this.selectedPrivateVideos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13.5.h,
      width: 10.5.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0.w),
        border: Border.all(color: ColorConstants.gray.withOpacity(0.5)),
        shape: BoxShape.rectangle,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              height: 10.h,
              width: 10.h,
              child: CustomNetworkImage(
                imageUrl: subUser.user?.imageUrl ??
                    'https://via.placeholder.com/300.png/09f/fff%20C/O%20https://placeholder.com/',
              ),
            ),
          ),
          Spaces.x3,
          Text(
            '${subUser.user?.getFullName()}',
            style: Get.textTheme.button!.copyWith(
              color: ColorConstants.appBlack,
              fontSize: 12.sp,
              fontFamily: FontConstants.montserratBold,
            ),
          ),
          const Spacer(),
          SendVideoButton(
            subUser: subUser,
            selectedPrivateVideos: selectedPrivateVideos,
          ),
        ],
      ),
    );
  }
}

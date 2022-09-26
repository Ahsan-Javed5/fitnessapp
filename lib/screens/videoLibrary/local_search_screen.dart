import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/constants/view_as_type.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups_controller.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_list_item.dart';
import 'package:fitnessapp/screens/videoLibrary/local_search_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../video_player_screen.dart';
import 'video_library_controller.dart';

class LocalSearchScreen extends StatelessWidget {
  /// 0 for Private Group
  /// 1 for Videos List
  /// 2 for Main Groups
  /// 3 for Sub Groups
  /// 4 for Subscriptions
  final String searchType;
  final bool shouldGoToVideoDetailScreen;

  LocalSearchScreen(
      {Key? key,
      required this.searchType,
      this.shouldGoToVideoDetailScreen = false})
      : super(key: key);
  final ctr = Get.find<LocalSearchController>();
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool hasFocus = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Column(
            children: [
              Row(
                children: [
                  /// Cross button
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, top: 8.0, left: 8.0),
                      child: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                    ),
                    onTap: () {
                      if (hasFocus) {
                        if (searchType == '0') {
                          ctr.searchPrivateGroups('');
                        } else if (searchType == '1') {
                          ctr.searchPrivateVideos('');
                        } else if (searchType == '2') {
                          ctr.searchMainGroups('');
                        } else if (searchType == '3') {
                          ctr.searchSubGroups('');
                        } else if (searchType == '4') {
                          ctr.searchSubscriptions('');
                        }

                        textEditingController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      } else {
                        Get.back();
                      }
                    },
                  ),

                  Spaces.x2,

                  /// Search bar
                  Expanded(
                    child: MySearchbarV3(
                      filterListener: () => Get.toNamed(Routes.filterScreen),
                      textEditingController: textEditingController,
                      hasFilterIcon: false,
                      onChange: (s) {
                        switch (searchType) {
                          case '0':
                            ctr.searchPrivateGroups(s.toLowerCase());
                            break;
                          case '1':
                            ctr.searchPrivateVideos(s.toLowerCase());
                            break;
                          case '2':
                            ctr.searchMainGroups(s.toLowerCase());
                            break;
                          case '3':
                            ctr.searchSubGroups(s.toLowerCase());
                            break;
                          case '4':
                            ctr.searchSubscriptions(s.toLowerCase());
                        }
                      },
                      focusListener: (b) => hasFocus = b,
                    ),
                  ),
                ],
              ),
              Spaces.y6,
              Expanded(
                child: GetBuilder<LocalSearchController>(
                    id: 'local_builder',
                    builder: (controller) {
                      switch (searchType) {
                        case '0':
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tempGroups.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempGroups[index];
                              return GroupListItem(
                                index: index,
                                translatedTitle: item.title ?? '',
                                customPlaceholder:
                                    'assets/images/private_group_placeholder.png',
                                imagePaddingSpace: Spaces.x5,
                                onPressed: () {
                                  Get.back();
                                  Get.find<VideoLibraryController>()
                                      .userSelectedPrivateGroup = item;
                                  Get.toNamed(Routes.privateGroupVideoView);
                                },
                                tag1Text: item.formattedCreatedAtTime,
                              );
                            },
                          );
                        case '1':
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tempVideos.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempVideos[index];
                              return GroupListItem(
                                index: index,
                                translatedTitle: item.title,
                                description: item.description,
                                tag1Text: item.duration,
                                imageUrl: item.videoUrl ?? '',
                                isVideo: true,
                                isTitleBold: false,
                                onPressed: () {
                                  if (!shouldGoToVideoDetailScreen) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => VideoPlayerScreen(
                                        url: item.videoUrl ?? '',
                                        videoId: item.id ?? -1,
                                        processStatus: item.isProcessed ?? 0,
                                        videoStreamUrl:
                                            item.videoStreamUrl ?? '',
                                      ),
                                      useSafeArea: false,
                                    );
                                  } else {
                                    /// user is coach and show ui accordingly
                                    final c = Get.put(VideoListController());
                                    final fpc =
                                        Get.find<FreeAndPaidGroupController>();

                                    c.videoList.clear();
                                    c.videoList
                                        .addAll(controller.allVideos ?? []);
                                    c.navigationString =
                                        '${fpc.userSelectedMainGroup?.title ?? ''} > ${fpc.userSelectedSubGroup?.title ?? ''}';
                                    c.workoutProgramTypeString = MyHive
                                                .getUser()
                                            ?.userWorkoutProgramTypesToString() ??
                                        '';
                                    c.setVideoDetailData(index);
                                    Get.toNamed(Routes.videoDetailScreen,
                                        arguments: {'viewAs': ViewAsType.self});
                                  }
                                },
                              );
                            },
                          );
                        case '2':
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tempMainGroups.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempMainGroups[index];
                              return GroupListItem(
                                  index: index,
                                  translatedTitle: item.title,
                                  description: item.description,
                                  tag1Text: MyHive.getUser()
                                      ?.userWorkoutProgramTypesToString(),
                                  imageUrl: item.groupThumbnail ?? '',
                                  onPressed: () {
                                    Get.find<FreeAndPaidGroupController>()
                                        .userSelectedMainGroup = item;
                                    Get.toNamed(Routes.freePaidMainGroupScreen,
                                        arguments: item);
                                  });
                            },
                          );
                        case '3':
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tempSubGroups.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempSubGroups[index];
                              return GroupListItem(
                                  index: index,
                                  translatedTitle: item.title,
                                  description: item.description,
                                  tag1Text: MyHive.getUser()
                                      ?.userWorkoutProgramTypesToString(),
                                  imageUrl: item.groupThumbnail ?? '',
                                  onPressed: () {
                                    Get.find<FreeAndPaidGroupController>()
                                        .userSelectedSubGroup = item;
                                    Get.toNamed(
                                      Routes.freePaidSubGroupScreen,
                                      arguments: {'isFree': true},
                                    );
                                  });
                            },
                          );
                        case '4':
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tempSubs.length,
                            itemBuilder: (context, index) {
                              final item = controller.tempSubs[index];
                              return SubscriptionListItem(
                                index: index,
                                subscription: item,
                                translatedTitle: 'main_group'.tr,
                                tag1Text: 'strength_workouts'.tr,
                                tag2Text: 'dummy_date'.tr,
                                onPressed: () {
                                  if (MyHive.getUserType() == UserType.user) {
                                    Routes.to(Routes.coachProfile,
                                        arguments: {'data': item.user});
                                  }
                                },
                              );
                            },
                          );
                        default:
                          return const SizedBox();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/screens/coachProfile/group_list_item.dart';
import 'package:fitnessapp/screens/video_player_screen.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'local_search_controller.dart';
import 'local_search_screen.dart';
import 'video_library_controller.dart';

class MyVideosLibrary extends StatelessWidget {
  const MyVideosLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoLibraryController>();
    final searchController = Get.find<LocalSearchController>();
    controller.getAllPrivateVideos();

    return CustomScreen(
      hasRightButton: true,
      hasSearchBar: false,
      rightButton: IconButton(
        icon: SvgPicture.asset(
          'assets/svgs/ic_search.svg',
          color: ColorConstants.appBlack,
        ),
        onPressed: () {
          searchController.tempVideos.clear();
          searchController.allVideos = controller.allPrivateVideos;
          showDialog(
              context: context,
              builder: (context) => LocalSearchScreen(searchType: '1'),
              useSafeArea: false);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Private and View all videos button
          Spaces.y2_0,
          Text('video_library'.tr, style: TextStyles.mainScreenHeading),

          Spaces.y3,
          Expanded(
            child: Obx(
              () => controller.allPrivateVideos.isEmpty
                  ? const EmptyView(
                      showFullMessage: false,
                    )
                  : ListView.builder(
                      itemCount: controller.allPrivateVideos.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = controller.allPrivateVideos[index];
                        return GroupListItem(
                          index: index,
                          translatedTitle: item.title,
                          isVideo: true,
                          imageUrl: item.videoUrl ?? '',
                          tag1Text: item.duration,
                          description: item.description,
                          onPressed: () {
                            showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (context) => VideoPlayerScreen(
                                url: item.videoUrl ?? '',
                                videoId: item.id ?? -1,
                                processStatus: item.isProcessed ?? 0,
                                videoStreamUrl: item.videoStreamUrl ?? '',
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

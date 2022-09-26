import 'package:fitnessapp/coach_list_item.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/search_coaches_controller.dart';
import 'package:fitnessapp/widgets/actionBars/my_searchbar_v3.dart';
import 'package:fitnessapp/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchCoachesController controller = Get.put(SearchCoachesController());
    if (MyHive.getUserType() == UserType.user) {
      controller.genderType = MyHive.getUser()!.gender.toString();
    } else {
      if (Get.arguments != null) {
        controller.genderType = Get.arguments['gender'];
      }
    }
    controller.setGenderType(controller.genderType);

    double _crossAxisSpacing = 6;
    double _mainAxisSpacing = 4;
    int _crossAxisCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / 240;

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
                    child: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                    onTap: () => Get.back(),
                  ),

                  Spaces.x2,

                  /// Search bar
                  Expanded(
                    child: MySearchbarV3(
                      filterListener: () => Get.toNamed(Routes.filterScreen),
                      onChange: (searchText) {
                        controller.onSearchChanged(searchText);
                      },
                    ),
                  ),
                ],
              ),
              Spaces.y1_0,
              Expanded(
                child: GetBuilder<SearchCoachesController>(
                    id: 'user_search_coaches',
                    builder: (controller) {
                      return controller.workoutForList.isEmpty
                          ? const EmptyView(
                              showFullMessage: false,
                            )
                          : SingleChildScrollView(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _crossAxisCount,
                                  crossAxisSpacing: _crossAxisSpacing,
                                  mainAxisSpacing: _mainAxisSpacing,
                                  childAspectRatio: height,
                                ),
                                itemCount: controller.workoutForList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CoachListItem(
                                    coach: controller.workoutForList[index],
                                    onPressed: () {
                                      // bool preValue = Utils.isSubscribedUser();
                                      // MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
                                      // Get.toNamed(Routes.coachProfile)?.then((value) => MyHive.setSubscriptionType(preValue
                                      //       ? SubscriptionType.subscribed
                                      //       : SubscriptionType.unSubscribed),);

                                      Routes.to(Routes.coachProfile,
                                          arguments: {
                                            'data':
                                                controller.workoutForList[index]
                                          });
                                    },
                                  );
                                },
                              ),
                            );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

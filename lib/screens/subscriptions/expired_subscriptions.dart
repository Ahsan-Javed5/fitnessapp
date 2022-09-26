part of 'package:fitnessapp/screens/subscriptions/subscription_view_pager.dart';

class ExpiredSubscriptions extends StatelessWidget {
  const ExpiredSubscriptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.find();
    return GetBuilder<SubscriptionController>(
      id: controller.getActiveSubs,
      builder: (controller) {
        return controller.inActiveSubsList.isEmpty
            ? const EmptyView(
                showFullMessage: false,
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.tempInActiveSubs.length,
                itemBuilder: (context, index) {
                  return SubscriptionListItem(
                    index: index,
                    subscription: controller.tempInActiveSubs[index],
                    translatedTitle: 'main_group'.tr,
                    tag1Text: 'strength_workouts'.tr,
                    tag2Text: 'dummy_date'.tr,
                    onPressed: () {
                      if (MyHive.getUserType() == UserType.user) {
                        Routes.to(Routes.coachProfile, arguments: {
                          'data': controller.tempInActiveSubs[index].user
                        });
                      }
                    },
                  );
                },
              );
      },
    );
  }
}

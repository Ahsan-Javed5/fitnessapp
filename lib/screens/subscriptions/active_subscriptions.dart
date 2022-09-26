part of 'package:fitnessapp/screens/subscriptions/subscription_view_pager.dart';

class ActiveSubscriptions extends StatelessWidget {
  const ActiveSubscriptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.find();
    return GetBuilder<SubscriptionController>(
      id: controller.getActiveSubs,
      builder: (controller) {
        return controller.availSub == 0
            ? const EmptyView()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.tempActiveSubs.length,
                itemBuilder: (context, index) {
                  return SubscriptionListItem(
                    index: index,
                    subscription: controller.tempActiveSubs[index],
                    translatedTitle: 'main_group'.tr,
                    onPressed: () {
                      if (MyHive.getUserType() == UserType.user) {
                        Routes.to(Routes.coachProfile, arguments: {
                          'data': controller.tempActiveSubs[index].user
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

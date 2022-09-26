import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/user/user.dart';

class SeeMoreController extends BaseController {
  int offset = 0;
  final int _limit = 10;
  final List<User> coaches = <User>[];
  final String getCoachesEndpoint = 'api/user/get_coaches_on_dashboard';

  void getCoaches({
    bool showLoadingDialog = true,
    int offset = 0,
    int limit = 10,
  }) async {
    coaches.clear();

    Future.delayed(const Duration(milliseconds: 1), () async {
      final result = await getReq(
          getCoachesEndpoint, (json) => User.fromJson(json),
          showLoadingDialog: showLoadingDialog, query: {});

      if (!result.error) {
        final List<User> fetchedCoaches = [...?result.data];
        coaches.addAll(fetchedCoaches);
        if (result.data!.length > _limit - 1) offset++;
      }

      update([getCoachesEndpoint]);
    });
  }

  void loadMoreCoaches() async {
    getCoaches(showLoadingDialog: true, offset: offset, limit: _limit);
  }
}

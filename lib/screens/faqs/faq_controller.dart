import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/models/f_a_q.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FAQController extends BaseController {
  final String _getFAQsEP = 'api/frequent_questions/';
  final String _askQuestionEP = 'api/frequent_questions/ask_question';
  BaseResponse<FAQ> baseResponse = BaseResponse();
  final faqs = <FAQ>[].obs;

  void fetchFAQs() async {
    Future.delayed(const Duration(milliseconds: 1), () async {
      final _result = await getReq(
        _getFAQsEP,
        (json) => FAQ.fromJson(json),
      );

      if (!_result.error) {
        faqs.clear();
        if (_result.data != null) faqs.addAll([...?_result.data]);
      }
    });
  }

  void askQuestion(Map body) async {
    final _result = await postReq(
      _askQuestionEP,
      body,
      (json) => FAQ.fromJson(json),
      singleObjectData: true,
    );

    if (!_result.error) {
      FAQ f = _result.singleObjectData;
      faqs.add(f);
      Get.back();
    }
  }
}

import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:messenger/model/Keys.dart';

class VideoListController extends BaseController {
  var videoList = <Video>[];

  //Next Video
  var nextVideoList = <Video>[];
  Video? videoDetail;
  int nextIndex = 0;

  final isDataLoaded = false.obs;

  var groupTitle = '';
  var groupDescription = '';
  var createdData = '';

  int? id;
  var type;
  var dataType;
  int limit = 10;
  int offset = 0;
  var body = <String, dynamic>{};

  /// navigation string
  /// e.g Main Group 1 > Sub Group 2
  String? navigationString;

  /// workout program type string
  String? workoutProgramTypeString;

  /// In subscribed user flow we need this to initiate chat with coach
  String? coachFirebaseKey;

  /// is coach allowed private chat or not
  bool isAllowChat = true;

  final String _getVideoByIdEndPoint = 'api/coach_group/video/';

  setData(String title, String des, String date) {
    groupTitle = title;
    groupDescription = des;
    createdData = date;
  }

  setVideoDetailData(int index) {
    videoDetail = videoList[index];
    nextIndex = (index + 1);
    nextVideoList.clear();
    if (nextIndex < videoList.length) {
      nextVideoList.add(videoList[nextIndex]);
    }
    update(['video_detail']);
  }

  setVideoDetailListData() {
    videoDetail = videoList[nextIndex];
    nextIndex = (nextIndex + 1);
    nextVideoList.clear();
    if (nextIndex < videoList.length) {
      nextVideoList.add(videoList[nextIndex]);
    }
    update(['video_detail_list']);
  }

  setRequestParam(String type, String dataType, int id) {
    this.dataType = dataType;
    this.type = type;
    this.id = id;
    body['text'] = dataType;
    body['type'] = type;
    body['limit'] = limit.toString();
    body['offset'] = offset.toString();
    body['id'] = id.toString();
    Future.delayed(1.milliseconds, () => getVideo(body));
  }

  getVideo(Map<String, dynamic> body) async {
    videoList.clear();
    final response = await getReq(
        'api/coach_group/videos', (json) => Video.fromJson(json),
        singleObjectData: false, showLoadingDialog: true, query: body);

    if (!response.error && response.data != null && response.data!.isNotEmpty) {
      List<Video> list = response.data!.cast<Video>();
      videoList.addAll(list);
      update(['api/coach_group/videos']);
    }
  }

  void getVideoFromId(String videoId) async {
    isDataLoaded.value = false;
    var response = await getReq(
        '$_getVideoByIdEndPoint$videoId', (p0) => Video.fromJson(p0),
        showLoadingDialog: false);
    if (!response.error) {
      var videoObj = response.data?[0];
      if (videoObj != null) {
        videoDetail = videoObj;
        if (videoDetail?.user != null) {
          coachFirebaseKey = videoDetail?.user?.firebaseKey;
          isAllowChat = videoDetail?.user?.allowPrivateChat ?? false;
        }
        isDataLoaded.value = true;
      }
    }
  }

  /// This method is basically being used to send video message but it is being sent for 2 purposes
  /// [1] Video message to admin to report a video
  /// [2] Video message to coach for asking him a question
  /// if [sendToAdmin] is false that means user is trying to send this message
  /// to [coachId] discussed in point [2] otherwise its being used for point [1]
  void sendReportMessage(
      {required Video video,
      bool sendToAdmin = true,
      String coachId = '',
      String? text}) async {
    final extraMap = {
      'nav_path': '$navigationString > Video ${video.id}',
      'title_en': video.title_en ?? '',
      'title_ar': video.title_ar ?? '',
      'video_id': video.id.toString(),
      'video_thumbnail': video.thumbnail,
      Keys.MessageVideoURL: video.videoStreamUrl ?? '',
    };

    Utils.open1to1Chat(
      MyHive.getUser()!.firebaseKey ?? '',
      sendToAdmin ? MyHive.adminFBEntityKey : coachId,
      Get.context!,
      arguments: extraMap,
    );
  }
}

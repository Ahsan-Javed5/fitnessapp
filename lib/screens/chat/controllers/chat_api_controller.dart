import 'dart:io';

import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/subscription.dart' as sub;
import 'package:fitnessapp/models/subscription_check.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/coachProfile/coachOwnProfile/coach_own_profile_controller.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Keys.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageMetaValue.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:messenger/model/ReplyConversation.dart';
import 'package:messenger/model/Thread.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

import '../../../config/fcm_controller.dart';

class ChatApiController extends BaseController {
  final isSubscribed = false.obs;
  final isAPILoading = true.obs;
  final status = 'loading'.obs;
  final mProgressValue = 0.0.obs;
  final MyImagePicker _picker = MyImagePicker();
  final storage = AzureStorage.parse(MyHive.azureConnectionString);
  RxString videoNavString = ''.obs;

  checkSubscriptionStatus(String targetUser) async {
    if (targetUser.isEmpty) return;

    /// if target user is admin then we don't have to check for subscription
    if (MyHive.adminFBEntityKey == targetUser ||
        MyHive.getUser()!.firebaseKey == MyHive.adminFBEntityKey) {
      isSubscribed.value = true;
      isAPILoading.value = false;
      return;
    }
    Future.delayed(1.milliseconds, () async {
      isAPILoading.value = true;
      final currentUsername = MyHive.getUser()?.userName;

      String username = '';
      String coachName = '';

      /// if current user is coach then the target user is of user type
      if (MyHive.getUserType() == UserType.coach) {
        username = targetUser;
        coachName = currentUsername!;
      } else {
        username = currentUsername!;
        coachName = targetUser;
      }

      final result = await getReq(
        'api/user/check_subscription',
        (json) => SubscriptionCheck.fromJson(json),
        singleObjectData: false,
        query: {
          'user_name': username,
          'coach_name': coachName,
        },
      );

      isAPILoading.value = false;
      if (result.error) {
        Utils.showSnack(
            'alert', 'Cannot check subscription status please try again');
      } else {
        final subCheck = result.data?[0].isSubscribed;
        isSubscribed.value = subCheck;
      }
    });
  }

  Future<void> selectImage({
    required ValueChanged<String?> onImageUploadedDone,
    required ImageSource source,
  }) async {
    bool iosPhoto = await Permission.photos.request().isGranted;
    if (!iosPhoto) {
      await Permission.photos.request();
      await Permission.mediaLibrary.request();
    }
    try {
      XFile? _selectedImage = await _picker.pickImage(source: source);
      if (_selectedImage != null) {
        File? imageFile = File(_selectedImage.path);
        await uploadFile(
          file: imageFile,
          onFileUploaded: (String? value) {
            onImageUploadedDone(value);
          },
        );
      }
    } catch (e) {
      log(message: e.toString());
    }
  }

  Future<void> uploadFile({
    File? file,
    required ValueChanged<String?> onFileUploaded,
    String? fileName,
  }) async {
    setLoading(true, isVideo: true);
    final fName = file!.path.split('/').last;
    final name = fileName ?? fName;
    await storage.putBlob(
      '${MyHive.azureContainer}$name',
      body: file.path,
      contentType: AzureStorage.getImgExtension(file.path),
      bodyBytes: file.readAsBytesSync(),
      onProgressChange: (d) {
        progressValue.value = d;
      },
      onUploadComplete: (url) async {
        log(message: 'THis was the uploaded url $url');
        setLoading(false);
        onFileUploaded(url);
        return url;
      },
      onUploadError: (e) {
        setLoading(false);
        setError(true);
        setMessage(e);
        onFileUploaded(null);
      },
    );
  }

  Future<void> uploadAudioFile({
    File? file,
    required ValueChanged<String?> onFileUploaded,
  }) async {
    setLoading(true, isVideo: true);
    final name = file!.path.split('/').last;
    await storage.putBlob(
      '${MyHive.azureContainer}$name',
      body: file.path,
      contentType: AzureStorage.getAudioExtension(file.path),
      bodyBytes: file.readAsBytesSync(),
      onProgressChange: (d) {
        progressValue.value = d;
      },
      onUploadComplete: (url) async {
        log(message: 'THis was the uploaded url $url');
        setLoading(false);
        onFileUploaded(url);
      },
      onUploadError: (e) {
        setLoading(false);
        setError(true);
        setMessage(e);
        onFileUploaded(null);
      },
    );
  }

  /// [subUser] this will be the user to whom we are going to send [items]
  /// [items] -> list of picked videos from the private section
  /// [ThreadsController.fetchOrCreatePrivate1to1Thread] this will help to find or create the user thread inside firebase
  Future<void> sendVideoChatMessage({
    required RxList<Video> items,
    required sub.Subscription subUser,
    required VoidCallback onMessageSent,
    required VoidCallback onError,
  }) async {
    var cUserId = MyHive.getUser()!.firebaseKey;
    var targetUserId = subUser.user?.firebaseKey;
    await ThreadsController.fetchOrCreatePrivate1to1Thread(
            cUserId!, targetUserId!)
        .then((value) {
      if (value == null) return;

      if (value.isError) {
        Utils.showSnack('Error', value.message, isError: true);
        return;
      }
      for (var item in items) {
        log(message: item.id.toString());
        _sendMessage(
          messageType: MessageType.Video,
          dataToSend: item.videoStreamUrl,
          fcm: value.displayUserFcm ?? '',
          currentUserId: cUserId,
          onMessageSent: onMessageSent,
          onError: onError,
          thread: value,
          video: item,
        );
      }
    });
  }

  void _sendMessage({
    required int messageType,
    required String? dataToSend,
    required String fcm,
    required String currentUserId,
    required VoidCallback onMessageSent,
    required VoidCallback onError,
    required Thread thread,
    required Video video,
  }) {
    List<String> receiverList = <String>[];
    thread.users?.forEach((element) {
      if (element.entityID != currentUserId) {
        receiverList.add(element.entityID!);
      }
    });

    MessageMetaValue meta =
        MessageMetaValue(videoUrl: dataToSend, type: messageType);
    meta.extraMap = {
      'nav_path': '$videoNavString > Video ${video.id}',
      'title_en': video.title_en ?? '',
      'title_ar': video.title_ar ?? '',
      'video_id': video.id.toString(),
      'video_thumbnail': video.thumbnail,
      Keys.MessageVideoURL: video.videoStreamUrl ?? '',
    };
    Message msg = Message(
      '',
      0.0,
      MessageType.ChatMessageHandler,
      0,
      0.0,
      0.0,
      0.0,
      null,
      null,
      null,
      null,
      currentUserId,
      currentUserId,
      meta,
      ReplyConversation(isReply: false, messageId: '', userId: ''),
      null,
    );
    msg.threadEntityId = thread.entityId!;
    msg.to = receiverList;
    ThreadsController.sendMessage(msg).then((value) {
      if (value.isError) {
        Utils.showSnack('Error', '${value.message}: Message is not delivered',
            isError: true);
        onError.call();
        return;
      }
      videoNavString.value = '';
      String title = 'Chat Message';
      String body = '${MyHive.getUser()?.getFullName()}: $dataToSend';
      FCMController()
          .sendPushNotification(fcm, title, body, {'senderId': currentUserId});
      onMessageSent.call();
      return;
    }).onError((error, stackTrace) {
      onError.call();
      log(message: error.toString());
    });
  }

  Future<void> uploadVideoFile({
    required String videoPath,
    required File videoFile,
    required void Function(String, String) onFileUploaded,
  }) async {
    status.value = 'loading';
    Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        barrierDismissible: false,
        onWillPop: () {
          return Future.value(false);
        },
        content: Column(
          children: [
            Obx(() {
              return Text(
                status.value.tr,
                style: TextStyles.headingAppBlackBold,
              );
            }),
            Spaces.y2,
            Obx(() {
              return LinearProgressIndicator(value: mProgressValue.value);
            }),
            Spaces.y2,
          ],
        ));

    /// Compressing
    status.value = 'compressing';
    await VideoCompress.setLogLevel(0);
    Subscription subscription =
        VideoCompress.compressProgress$.subscribe((progress) {
      mProgressValue.value = progress / 100;
    });
    File? renamedFile;
    if (Platform.isIOS && videoFile.path.contains(' ')) {
      renamedFile = await Utils.changeFileNameOnly(
          File.fromUri(Uri.parse(videoFile.path)),
          '${DateTime.now().microsecondsSinceEpoch}newVideo.mov');
    }

    ///here he is compressing video!
    final MediaInfo? info = await VideoCompress.compressVideo(
      renamedFile?.path ?? videoFile.path,
      quality: VideoQuality.HighestQuality,
      deleteOrigin: true,
      includeAudio: true,
    );
    subscription.unsubscribe();
    File file = File(info!.path!);

    /// Create Thumbnail and upload
    status.value = 'Thumbnailing...';
    final uInt8List = await Utils.getThumbnailFromVideoFile(file.path);
    final imageFile = await Utils.uInt8ListToTempImageFile(uInt8List);
    var coach = Get.isRegistered<CoachOwnProfileController>()
        ? Get.find<CoachOwnProfileController>()
        : Get.put(CoachOwnProfileController());
    String thumbnailUrl = await coach.uploadImage(
      imageFile!,
      '${DateTime.now().microsecondsSinceEpoch}thumbnail.png',
    );

    /// Uploading Video
    status.value = 'uploading';
    mProgressValue.value = 0;
    String uploadURL =
        '${MyHive.azureContainer}${info.path!.split('\/').last.replaceAll(' ', '_')}';
    await storage.putBlob(
      uploadURL,
      body: file.path,
      contentType: 'application/octet-stream',
      bodyBytes: file.readAsBytesSync(),
      onProgressChange: (d) {
        return mProgressValue.value = d;
      },
      onUploadComplete: (s) async {
        log(message: s);
        onFileUploaded.call(s, thumbnailUrl);
      },
      onUploadError: (e) {
        setError(true);
        setMessage(e);
      },
    );
  }
}

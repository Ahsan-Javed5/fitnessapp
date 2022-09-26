import 'dart:async';
import 'dart:io';

import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/bank.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/profileSetup/contract_page.dart';
import 'package:fitnessapp/screens/profileSetup/subscription_page.dart';
import 'package:fitnessapp/screens/profileSetup/upload_intro_video_screen.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import 'bank_details_page.dart';

class ProfileSetupController extends BaseController {
  var currentIndex = 0.obs;
  final List<int> _backstack = [0];
  final countries = [];
  final banks = [];
  final bankDetailsKey = GlobalKey<FormBuilderState>();
  final uploadDocumentKey = GlobalKey<FormBuilderState>();
  final subscriptionKey = GlobalKey<FormBuilderState>();
  final String _removeIntroVideoEndPoint = 'api/user/remove_intro_video';
  final String _addIntroVideoEndPoint = 'api/user/add_intro_video';
  bool isUpdateButtonEnabled = true;
  final storage = AzureStorage.parse(MyHive.azureConnectionString);

  var selectedCountryIsQatar = true.obs;
  var showIbanField = true.obs;

  /// Video upload
  final status = 'loading'.obs;
  final mProgressValue = 0.0.obs;

  /// Body
  final Map<String, dynamic> body = <String, dynamic>{};

  /// Files
  File? signatureImageFile;
  File? documentImageFile;

  /// Endpoint
  final String _updateProfileDetailsEndPoint = 'api/coach/add_coach_details/';
  final String getAllBanksEndPoint = 'api/banks/banksListing';

  ///intro video
  RxString videoUrl = (MyHive.getUser()?.coachIntroVideo?.videoUrl ?? '').obs;
  String videoThumbnail = MyHive.getUser()?.coachIntroVideo?.thumbnail ?? '';

  final fragments = const [
    BankAccountDetailsPage(),
    //UploadDocumentPage(),
    ContractPage(),
    SubscriptionPage(),
    UploadIntroVideoScreen(),
  ];

  void setSignatureImageFile(File file) async {
    await signatureImageFile?.delete();
    signatureImageFile = file;
    update(['signature_pad']);
  }

  void init() {
    _backstack.clear();
    currentIndex.value = 0;
    _backstack.add(currentIndex.value);
  }

  void navigateBack() {
    if (currentIndex.value == 0) {
      Utils.clearDataAndGotoLogin();
    } else {
      _backstack.remove(currentIndex.value);
      currentIndex--;
    }
  }

  void navigateForward() {
    if (currentIndex.value + 1 >= fragments.length) return;
    currentIndex++;
    _backstack.add(currentIndex.value);
  }

  void getAllCountries() async {
    /// just for development stage
    countries.clear();
    update([getCountriesEndPoint]);

    await Future.delayed(1.milliseconds, () async {
      final result =
          await getReq(getCountriesEndPoint, (json) => Country.fromJson(json));
      if (result.data != null) countries.addAll(result.data ?? []);
      update([getCountriesEndPoint]);
    });
  }

  void getAllBanks() async {
    /// just for development stage
    banks.clear();
    update([getAllBanksEndPoint]);

    await Future.delayed(1.milliseconds, () async {
      final result =
          await getReq(getAllBanksEndPoint, (json) => Bank.fromJson(json));
      if (result.data != null) banks.addAll(result.data ?? []);
      update([getAllBanksEndPoint]);
    });
  }

  void updateCoachProfileDetails() async {
    Future.delayed(1.milliseconds, () async {
      if (signatureImageFile == null) {
        Utils.showSnack('alert'.tr, 'please_sign_in_the_contract_first'.tr);
      } else if (body['country_id'] == null) {
        Utils.showSnack('alert'.tr, 'please_select_country'.tr);
      } else if (body['bank_name'] == null) {
        Utils.showSnack('alert'.tr, 'please_select_your_bank'.tr);
      } else {
        final countryName = body['country_id'] as String;

        body['user_id'] = MyHive.getUser()?.id;
        body['bank_id'] = body['bank_name'];
        body['country_id'] = Utils.getIdOfValue(countries, countryName);
        body['video'] = videoUrl.value;

        String? accountNumber = body['account_number'];
        if (accountNumber?.isEmpty ?? true) {
          body.remove('account_number');
        }

        setLoading(true, isVideo: true);
        final name = signatureImageFile!.path.split('/');
        isUpdateButtonEnabled = false;
        await storage.putBlob('${MyHive.azureContainer}${name.last}',
            body: signatureImageFile!.path,
            contentType: AzureStorage.getImgExtension(signatureImageFile!.path),
            bodyBytes: signatureImageFile!.readAsBytesSync(),
            onProgressChange: (d) => progressValue.value = d,
            onUploadComplete: (url) async {
              if (MyHive.getUser()?.bankDetails?.currency == null) {
                setLoading(false);
                setLoading(true);

                /// save url on our server with other details
                log(message: url);

                body['signature'] = url;
                final res = await postReq(
                  _updateProfileDetailsEndPoint,
                  body,
                  (json) => User.fromJson(json),
                  singleObjectData: true,
                );
                setLoading(false);
                if (!res.error) {
                  isUpdateButtonEnabled = true;
                  MyHive.saveUser(res.singleObjectData);
                  Get.offAllNamed(Routes.onBoardingScreen);
                  //Get.offNamed(Routes.onBoardingScreen);
                }
              }
            },
            onUploadError: (e) {
              isUpdateButtonEnabled = true;
              setLoading(false);
              setError(true);
              setMessage(e);
            });
      }
    });
  }

  User? getUser() {
    User? user = MyHive.getUser();
    return user;
  }

  removeIntroVideo() async {
    Map body = {};
    final response = await postReq(
        _removeIntroVideoEndPoint, body, (video) => Video.fromJson(video));

    if (!response.error) {
      videoUrl.value = '';
      update(['introBuilder']);
      showSnackBar('alert'.tr, 'video_removed_successfully'.tr);
    }
  }

  _showUploadingDialog() {
    Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        barrierDismissible: false,
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
  }

  addIntroVideo(String videoPath, File videoFile) async {
    Map body = {};

    _showUploadingDialog();

    status.value = 'loading';

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
    String thumbnailUrl = await _uploadImage(
      imageFile!,
      '${DateTime.now().microsecondsSinceEpoch}thumbnail.png',
    );

    /// Uploading Video
    status.value = 'uploading';
    mProgressValue.value = 0;
    await storage.putBlob(
        '${MyHive.azureContainer}${DateTime.now().microsecondsSinceEpoch}.mp4',
        body: file.path,
        contentType: 'application/octet-stream',
        bodyBytes: file.readAsBytesSync(), onProgressChange: (d) {
      if (!(Get.isDialogOpen ?? false)) _showUploadingDialog();
      return mProgressValue.value = d;
    }, onUploadComplete: (s) async {
      status.value = 'finishing';

      /// save url on our server with other details
      body['video'] = s;
      body['thumbnail_url'] = thumbnailUrl;
      log(message: s);
      final response = await postReq(
        _addIntroVideoEndPoint,
        body,
        (video) => Video.fromJson(video),
        singleObjectData: true,
      );
      setMessage(response.message);
      Video? video = response.singleObjectData;
      if (!response.error && video != null) {
        User? user = MyHive.getUser();
        if (user != null) {
          videoUrl.value = video.videoUrl ?? '';
          videoThumbnail = video.thumbnail ?? '';
          user.coachIntroVideo = video;
          MyHive.saveUser(user);
          update(['introBuilder']);
        }
      }
    }, onUploadError: (e) {
      setError(true);
      setMessage(e);
    });
  }

  /// This method will upload the image on Azure and will return the url
  /// of that image on azure
  _uploadImage(File imageFile, String name) async {
    Completer completer = Completer<String>();
    await storage.putBlob('${MyHive.azureContainer}$name',
        body: imageFile.path,
        contentType: AzureStorage.getImgExtension(imageFile.path),
        bodyBytes: imageFile.readAsBytesSync(),
        onProgressChange: (d) {}, onUploadComplete: (url) async {
      /// save url on our server with other details
      log(message: url);

      completer.complete(url);
    }, onUploadError: (e) {
      setError(true);
      completer.complete('');
      setMessage(e);
    });

    return completer.future;
  }

  void toggleSelectedCountry(String selectedCountry) {
    selectedCountryIsQatar.value = selectedCountry.contains('qatar');

    if (!selectedCountry.contains('qatar') &&
        !selectedCountry.contains('saudi arabia') &&
        !selectedCountry.contains('uae') &&
        !selectedCountry.contains('united arab emirates') &&
        !selectedCountry.contains('oman') &&
        !selectedCountry.contains('kuwait') &&
        !selectedCountry.contains('bahrain')) {
      showIbanField.value = false;
    } else {
      showIbanField.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  InternalFinalCallback<void> get onDelete {
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    return super.onDelete;
  }
}

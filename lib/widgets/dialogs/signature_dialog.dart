import 'dart:io';

import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/font_constants.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_controller.dart';
import 'package:fitnessapp/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureDialog extends StatelessWidget {
  const SignatureDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileSetupController>();

    final _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: ColorConstants.appBlack,
      exportBackgroundColor: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Spaces.normX(4)),
            padding: EdgeInsets.only(
                bottom: Spaces.normY(4),
                top: Spaces.normY(1),
                right: Spaces.normX(4),
                left: Spaces.normX(4)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spaces.normX(2)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                /// Cross button and title
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'sign_here'.tr,
                          style: TextStyles.subHeadingSemiBold.copyWith(
                            fontSize: Spaces.normSP(15),
                            fontFamily: FontConstants.montserratBold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Spaces.normY(3),
                        width: Spaces.normY(3),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Get.back(),
                          icon: SvgPicture.asset('assets/svgs/ic_cross.svg'),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Signature Pad
                Spaces.y2,
                Container(
                  height: Spaces.normY(23),
                  child: Signature(
                    controller: _controller,
                    width: double.infinity,
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Spaces.normX(1)),
                    border: Border.all(color: ColorConstants.gray, width: 1.3),
                  ),
                ),

                /// Bottom buttons
                Spaces.y1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Reset button
                    SizedBox(
                      height: Spaces.normY(5.3),
                      width: Spaces.normY(10),
                      child: IconButton(
                        onPressed: () => _controller.clear(),
                        padding: EdgeInsets.zero,
                        icon: Container(
                          width: Spaces.normY(12),
                          height: Spaces.normY(5.3),
                          padding: EdgeInsets.all(Spaces.normX(1.5)),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.circular(Spaces.normX(1)),
                            color: Colors.white,
                            border: Border.all(
                                color: ColorConstants.appBlue, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.veryVeryLightGray,
                                offset: Offset(0, 1.5),
                                blurRadius: 1.5,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/svgs/ic_reset.svg',
                            color: ColorConstants.appBlue,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    /// Done button
                    SizedBox(
                      height: Spaces.normY(5.3),
                      width: Spaces.normY(12),
                      child: CustomElevatedButton(
                        text: 'done'.tr,
                        onPressed: () async {
                          final image = await _controller.toPngBytes();
                          if (image != null) {
                            final tempDir = await getTemporaryDirectory();
                            final file = await File(
                                    '${tempDir.path}/${DateTime.now()}.jpg')
                                .create();
                            file.writeAsBytesSync(image);
                            c.setSignatureImageFile(file);
                          }
                          Get.back();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

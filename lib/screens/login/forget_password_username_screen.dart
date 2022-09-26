import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

import 'forgot_password_screen.dart';
import 'forgot_username_screen.dart';

class ForgetPasswordUserNameScreen extends StatelessWidget {
  const ForgetPasswordUserNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      hasSearchBar: false,
      hasRightButton: false,
      child: Column(
        children: [
          /// Tabs and Tab children
          Expanded(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                children: [
                  TabBar(
                    labelStyle: TextStyle(fontSize: 14.sp),
                    unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                    indicatorWeight: 2,
                    tabs: [
                      Tab(
                        text: 'forgot_password'.tr,
                      ),
                      Tab(
                        text: 'forgot_username'.tr,
                      ),
                    ],
                  ),
                  Spaces.y4,
                  Expanded(
                    child: TabBarView(
                      children: [
                        ForgotPasswordScreen(),
                        ForgotUserNameScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

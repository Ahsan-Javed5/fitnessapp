import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/custom_screen.dart';
import 'package:fitnessapp/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Thread.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'chat_view_screen.dart';
import 'thread_item.dart';

class ThreadViewScreen extends StatefulWidget {
  const ThreadViewScreen({Key? key}) : super(key: key);

  @override
  _ThreadViewScreenState createState() => _ThreadViewScreenState();
}

class _ThreadViewScreenState extends State<ThreadViewScreen> {
  ThreadUserLinksProvider? provider;
  bool longPressActive = false;
  final controller = Get.find<MainMenuController>();

  ///This list will hold threads that user has selected by long press
  List<String> selectedThreads = <String>[];
  final appLevelController = Get.find<AppStateObserver>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      hasSearchBar: true,
      hasRightButton: true,
      backHandler: () => Navigator.of(context).pop(),
      onSearchBarTextChange: (p0) => controller.performSearch(p0),
      onSearchbarClearText: () => controller.performSearch(''),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateChatDialog(),
          );
        },
        child: const Icon(Icons.chat_outlined),
      ),*/
      rightButton: const HomeButton(),
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'messages'.tr,
                  style: TextStyles.mainScreenHeading,
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              AnimatedOpacity(
                duration: 300.milliseconds,
                opacity: selectedThreads.isEmpty ? 0 : 1,
                child: IconButton(
                  onPressed: () => setState(() {
                    selectedThreads.forEach((threadId) async {
                      await ThreadsController.deleteThread(
                          threadId, provider?.currentUserKey ?? '');
                    });
                    selectedThreads.clear();
                    longPressActive = false;
                  }),
                  icon: SvgPicture.asset('assets/svgs/ic_delete_red.svg'),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 3.h,
          ),

          ///ListView for showing threads of current user
          Expanded(
            child: Obx(
              () {
                final isChatEnabled = appLevelController.isChatEnabled.value;
                return Consumer<ThreadUserLinksProvider>(
                  builder: (ctx, obj, child) {
                    provider = null;
                    provider = obj;
                    controller.liveThreadsMap.clear();
                    Map<String, double> myMap =
                        Map<String, double>.from(provider?.threadsOfUser);
                    controller.liveThreadsMap.addAll(myMap);
                    final keys = provider!.threadsOfUser.keys.toList();
                    controller.performSearch('');
                    return GetBuilder<MainMenuController>(
                        id: 'thread_list_view',
                        builder: (c) {
                          final tempKeys =
                              controller.tempThreadsMap.keys.toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                c.searchEnabled ? tempKeys.length : keys.length,
                            itemBuilder: (context, position) {
                              String threadKey = c.searchEnabled
                                  ? tempKeys[position]
                                  : keys[position];
                              double lastActivity = c.searchEnabled
                                  ? c.tempThreadsMap[tempKeys[position]]
                                  : provider!.threadsOfUser[keys[position]];
                              return Stack(
                                children: [
                                  ///show selection mark if user long press a thread item
                                  GestureDetector(
                                    onLongPress: () {
                                      if (isChatEnabled) {
                                        _onLongPress(threadKey);
                                      }
                                    },

                                    ///normal thread item
                                    child: ThreadItem(
                                      position,
                                      threadKey,
                                      obj.currentUserKey ?? '',
                                      lastActivity,
                                      selectedThreads.contains(threadKey),
                                      (int pos, Thread thread) {
                                        _onThreadItemTap(
                                            pos, thread, isChatEnabled);
                                      },
                                      (String key, double date) {
                                        obj.updateThreadLastActivityTime(
                                            key, date);
                                      },
                                      key: Key(threadKey),
                                    ),
                                  ),

                                  ///Thread selection mark
                                  longPressActive
                                      ? selectedThreads.contains(threadKey)
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: 2.0.w,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SvgPicture.asset(
                                                    'assets/selection_mark.svg',
                                                    height: 17.0.w,
                                                    width: 17.0.w,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                      : const SizedBox(),
                                ],
                              );
                            },
                          );
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _onLongPress(String key) {
    setState(() {
      selectedThreads.add(key);
      longPressActive = !longPressActive;

      //if long press is deactivated then clear the list
      if (!longPressActive) selectedThreads.clear();
    });
  }

  _onThreadItemTap(
      int position, Thread thread, bool isChatEnabledWithOtherUsers) {
    if (longPressActive) {
      setState(() {
        if (selectedThreads.contains(thread.entityId)) {
          selectedThreads.remove(thread.entityId);
        } else {
          selectedThreads.add(thread.entityId ?? '');
        }
        if (selectedThreads.isEmpty) longPressActive = false;
      });
    } else {
      if (!isChatEnabledWithOtherUsers &&
          thread.receiverUserId != MyHive.adminFBEntityKey) {
        Utils.showSnack('alert', 'messaging_disabled_note');
        return;
      }
      Navigator.of(context)
          .push(Utils.createRoute(ChatViewScreen(
        currentUserId: provider?.currentUserKey ?? '',
        thread: thread,
        position: position,
      )))
          .then(
        (value) {
          //this will be called when user will come back from
          //chat view screen
          setState(() {
            longPressActive = false;
            selectedThreads.clear();
          });
        },
      );
    }
  }
}

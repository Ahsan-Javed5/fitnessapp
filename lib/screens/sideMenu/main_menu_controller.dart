import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';

class MainMenuController extends GetxController {
  /// Threads of a user that we need to listen for unread thread
  final userThreads = <String?, double>{};
  var unreadThreads = <String, bool>{}.obs;

  /// This map will hold a list of threads with there name
  var threadKeysNames = <String, String>{};

  /// This map will hold a list of all threads in correct order
  var liveThreadsMap = <String, double>{};

  /// This map will hold a list of threads that matched search query
  var tempThreadsMap = <String, double>{};
  bool searchEnabled = false;

  void updateThreadsListeners(ThreadUserLinksProvider value) async {
    if (value.threadsOfUser.length != userThreads.length) {
      final currentUserId = MyHive.getUser()?.firebaseKey ?? '';
      userThreads.clear();
      userThreads.addAll(value.threadsOfUser);
      userThreads.forEach((key, value) async {
        await ThreadsController.fetchThreadWithThreadIdLiveRef(
            key!, currentUserId, (t) {
          t.addListener(() {
            threadKeysNames[t.entityId ?? ''] = t.displayName ?? '';
            if (t.unreadCount > 0) {
              unreadThreads[t.entityId!] = true;
            } else {
              unreadThreads.remove(t.entityId);
            }
          });
        });
      });
    }
  }

  notifyProfileUpdated() {
    update(['profileUpdate']);
    update(['profileUpdateHome']);
  }

  performSearch(String query) {
    if (query.isEmpty) {
      searchEnabled = false;
      update(['thread_list_view']);
      return;
    }

    tempThreadsMap.clear();
    searchEnabled = true;
    final lowerCaseQuery = query.toLowerCase();

    threadKeysNames.forEach((key, value) {
      if (value.toLowerCase().contains(lowerCaseQuery)) {
        tempThreadsMap[key] = liveThreadsMap[key] ?? 0;
      }
    });
    update(['thread_list_view']);
  }

  closeObservers() {
    userThreads.clear();
    tempThreadsMap.clear();
    liveThreadsMap.clear();
    threadKeysNames.clear();
    unreadThreads.clear();
  }
}

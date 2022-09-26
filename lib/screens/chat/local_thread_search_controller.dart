import 'package:get/get.dart';
import 'package:messenger/model/Thread.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';

class LocalThreadSearchController extends GetxController {
  final originalThreads = <Thread>[];
  final copiedList = <Thread>[];

  performSearch(String query) {
    if (query.isEmpty) {
      copiedList.clear();
      copiedList.addAll(originalThreads);
      update(['thread_list_view']);
      return;
    }

    copiedList.clear();
    final lowerCaseQuery = query.toLowerCase();
    for (Thread t in originalThreads) {
      if (t.displayName!.toLowerCase().contains(lowerCaseQuery)) {
        copiedList.add(t);
        update(['thread_list_view']);
      }
    }
  }

  void updateThreadLists(ThreadUserLinksProvider provider) {
    originalThreads.clear();
    copiedList.clear();
    originalThreads.add(provider.threadsOfUser);
    copiedList.add(provider.threadsOfUser);
    update(['thread_list_view']);
  }
}

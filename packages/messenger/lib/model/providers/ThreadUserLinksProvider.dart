import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/ThreadUserLink.dart';

import '../Keys.dart';

class ThreadUserLinksProvider extends ChangeNotifier {
  final Map<String?, double> _threadUserLinkMap = <String?, double>{};
  String? currentUserKey;

  ThreadUserLinksProvider(String userFirebaseId) {
    initProvider(userFirebaseId);
  }

  StreamSubscription? subscription;

  initProvider(String userFirebaseId) {
    currentUserKey = userFirebaseId;
    if (subscription != null) {
      subscription!.cancel();
    }
    if (currentUserKey == null || currentUserKey!.isEmpty) return;

    subscription = ThreadsController.dbRef
        .child(Keys.Users)
        .child(userFirebaseId)
        .child(Keys.Threads)
        .onValue
        .listen(
      (event) {
        if (event.snapshot != null) {
          var snapValues = event.snapshot.value;
          if (snapValues != null) {
            var threads = <ThreadUserLink>[];
            snapValues.forEach(
              (key, value) {
                threads.add(ThreadUserLink.fromJsonWithId(
                    Map<String, dynamic>.from(value), key));
              },
            );
            _threadUserLinkMap.clear();
            threads.forEach(
              (element) {
                _threadUserLinkMap[element.key] = 0.0;
              },
            );
            notifyListeners();
          }
        }
      },
    );
  }

  get threadsOfUser {
    return _threadUserLinkMap;
  }

  void updateThreadLastActivityTime(String threadKey, double date) {
    _threadUserLinkMap[threadKey] = date;
    var mapEntries = _threadUserLinkMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _threadUserLinkMap
      ..clear()
      ..addEntries(mapEntries);
    notifyListeners();
  }
}

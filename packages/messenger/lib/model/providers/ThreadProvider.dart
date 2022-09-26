import 'package:flutter/cupertino.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/model/Thread.dart';

///Experimental work
///Work is still in progress
///Objective: Listen for thread changes globally
class ThreadProvider extends ChangeNotifier {
  Thread? _thread;

  ThreadProvider(String threadEntityID, String currentUserId) {
    ThreadsController.dbRef
        .child('threads')
        .child(threadEntityID)
        .onValue
        .listen((event) {
      if (event.snapshot == null) {
        _thread = Thread.defaultValues();
      } else {
        if (!Glob().isThreadItemListenerEnabled()) return;

        Map map = event.snapshot.value;
        _thread = Thread.rawMapWithId(
            map: Map<String, dynamic>.from(map),
            entityId: threadEntityID,
            currentUserId: currentUserId);
        notifyListeners();
      }
    });
  }

  get getThread => _thread;
}

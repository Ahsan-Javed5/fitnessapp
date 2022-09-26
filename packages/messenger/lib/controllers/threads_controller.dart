import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/Keys.dart';
import 'package:messenger/model/Message.dart';
import 'package:messenger/model/MessageType.dart';
import 'package:messenger/model/ReadType.dart';
import 'package:messenger/model/Thread.dart';
import 'package:messenger/model/ThreadType.dart';
import 'package:messenger/model/ThreadUserLink.dart';

import '../config/Glob.dart';

class ThreadsController {
  static const String CHATS = 'chats',
      RECENT = 'recentChats',
      MESSAGES = 'messages',
      THREADS = 'threads',
      USERS = 'users';
  static var dbRef = FirebaseDatabase.instance.reference().child(Glob.rootNode);

  ///Objectives for creating a new thread
  // 0) Check if both user already have a common thread
  // 1) else create Thread in threads node
  static Future<Thread> fetchOrCreatePrivate1to1Thread(
      String currentUserEntityKey, String targetUserEntityKey) async {
    Completer<Thread> completer = Completer();

    //Step Zero
    List<String?> currentUserThreads =
        await fetchAllThreadsOfUser(currentUserEntityKey);

    List<String?> targetUserThreads =
        await fetchAllThreadsOfUser(targetUserEntityKey);
    String? existingThreadId;

    if (currentUserThreads.isNotEmpty && targetUserThreads.isNotEmpty) {
      //check if they have a common thread
      for (int i = 0; i < currentUserThreads.length; i++) {
        if (targetUserThreads.contains(currentUserThreads[i])) {
          existingThreadId = currentUserThreads[i];
          break;
        }
      }

      ///[fetchThreadWithThreadIdRef(_,_)] this method will return the thread and information
      ///relative to the user
      if (existingThreadId == null) {
        Thread newThread = await _createPrivate1To1Thread(
            currentUserEntityKey, targetUserEntityKey);

        if (newThread.isError) {
          completer.complete(newThread);
        } else {
          completer.complete(await fetchThreadWithThreadIdRef(
              newThread.entityId!, currentUserEntityKey));
        }
      } else {
        completer.complete(await fetchThreadWithThreadIdRef(
            existingThreadId, currentUserEntityKey));
      }
    } else {
      //just create thread
      Thread newThread = await _createPrivate1To1Thread(
          currentUserEntityKey, targetUserEntityKey);

      if (newThread.isError) {
        completer.complete(newThread);
      } else {
        completer.complete(await fetchThreadWithThreadIdRef(
            newThread.entityId!, currentUserEntityKey));
      }
    }

    return completer.future;
  }

  ///This method will return a parsed list of all the private threads in the database
  ///this will return null if no private thread is found
  ///this will return the objects with entity id
  static Future<List<Thread>> fetchAllPrivateThreads() {
    Completer<List<Thread>> completer = Completer();

    dbRef
        .child('threads')
        .orderByChild('meta/type')
        .equalTo(ThreadType.Private1to1)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        completer.complete(<Thread>[]);
      } else {
        Map map = snapshot.value;
        List<Thread> list = <Thread>[];

        map.forEach((key, value) {
          list.add(Thread.rawMapWithId(map: value, entityId: key));
        });

        completer.complete(list);
      }
    }).catchError((error) {
      completer.complete(<Thread>[]);
    });

    return completer.future;
  }

  ///This method will return a parsed list of all the threads of [entityId] in the database
  ///this will return null if no thread is found for this [entityId]
  static Future<List<String?>> fetchAllThreadsOfUser(String entityId) async {
    final completer = Completer<List<String?>>();

    final userThreads = <String>[];

    dbRef
        .child(Keys.Users)
        .child(entityId)
        .child(Keys.Threads)
        .once()
        .then((value) {
      if (value == null || value.value == null) {
        completer.complete(userThreads);
      } else {
        Map<String, dynamic> snapValues =
            Map<String, dynamic>.from(value.value);
        if (snapValues == null) {
          completer.complete(userThreads);
        } else {
          snapValues.forEach((key, value) {
            userThreads.add(key);
          });
          completer.complete(userThreads);
        }
      }
    });
    return completer.future;
  }

  static String filterVal(String val) {
    List<String> inCorrects = [':', '#', '\$', '[', ']', '.'];
    String filtered = val;
    inCorrects.forEach((val) {
      filtered = filtered.replaceAll(val, '');
    });
    return filtered;
  }

  //Returns a thread object with all the details available based on entityId
  //and returns null if find nothing
  static Future<Thread> fetchThreadWithThreadId(String existingThreadId) async {
    Completer<Thread> completer = new Completer<Thread>();
    dbRef.child('threads').child(existingThreadId).once().then((value) {
      if (value.value == null) {
        completer.complete(null);
      } else {
        Thread thread = Thread.rawMapWithId(
            map: Map<String, dynamic>.from(value.value),
            entityId: existingThreadId);
        completer.complete(thread);
      }
    });

    return completer.future;
  }

  //Returns a thread object with all the details available and observe for changes based on entityId
  //and returns null if find nothing
  static Future<StreamSubscription<Event>> fetchThreadWithThreadIdLive(
      String threadEntityID, void onData(Thread thread)) async {
    StreamSubscription<Event> subscription =
        dbRef.child('threads').child(threadEntityID).onValue.listen((event) {
      if (event.snapshot == null) {
        onData(Thread.defaultValues());
      } else {
        Map map = event.snapshot.value;
        onData(Thread.rawMapWithId(
            map: Map<String, dynamic>.from(map), entityId: threadEntityID));
      }
    });

    return subscription;
  }

  /// This method will observe if the receiver is active or in inactive in the
  /// current thread
  static Future<StreamSubscription<Event>> observerTypingStatus(
      String threadEntityID,
      String receiverId,
      void onData(String status)) async {
    StreamSubscription<Event> subscription = dbRef
        .child('threads')
        .child(threadEntityID)
        .child('users')
        .child(receiverId)
        .child('typing')
        .onValue
        .listen((event) {
      onData(event.snapshot.value ?? '');
    });

    return subscription;
  }

  ///This method will return the thread with display details wrt to current user
  ///like display name and picture url
  static Future<StreamSubscription<Event>> fetchThreadWithThreadIdLiveRef(
      String threadEntityID,
      String currentUserId,
      void onData(Thread thread)) async {
    StreamSubscription<Event> subscription =
        dbRef.child('threads').child(threadEntityID).onValue.listen((event) {
      if (event.snapshot == null) {
        onData(Thread.defaultValues());
      } else {
        if (!Glob().isThreadItemListenerEnabled()) return;

        if (event.snapshot.value == null) {
          return;
        }
        Map map = event.snapshot.value;

        onData(Thread.rawMapWithId(
            map: Map<String, dynamic>.from(map),
            entityId: threadEntityID,
            currentUserId: currentUserId));
      }
    });

    return subscription;
  }

  static Future<Thread> fetchThreadWithThreadIdRef(
      String threadEntityID, String currentUserId) async {
    Completer<Thread> completer = Completer();

    dbRef.child('threads').child(threadEntityID).once().then((value) {
      completer.complete(Thread.rawMapWithId(
          map: Map<String, dynamic>.from(value.value),
          entityId: threadEntityID,
          currentUserId: currentUserId));
    }).onError((dynamic error, stackTrace) {
      completer.completeError(error, stackTrace);
    });

    return completer.future;
  }

  ///This method will go into the user node
  ///then its thread node
  ///then it will fetch the ids of all the threads listed in the threads node
  static Future<StreamSubscription<Event>> fetchThreadsOfUserLive(
      String userEntityId, void onData(List<ThreadUserLink> threads)) async {
    StreamSubscription<Event> subscription = dbRef
        .child(Keys.Users)
        .child(userEntityId)
        .child(Keys.Threads)
        .onValue
        .listen((event) {
      if (event.snapshot == null) {
        onData(<ThreadUserLink>[]);
      } else {
        var snapValues = event.snapshot.value;
        if (snapValues == null) {
          onData(<ThreadUserLink>[]);
        } else {
          var threads = <ThreadUserLink>[];
          snapValues.forEach((key, value) {
            threads.add(ThreadUserLink.fromJsonWithId(
                Map<String, dynamic>.from(value), key));
          });
          onData(threads);
        }
      }
    });

    return subscription;
  }

  // 1) create Thread in threads node
  //    1.1 -   create thread meta
  //    1.2 -   create thread details
  //    1.3 -   create thread user and add target and current user
  // 2) update the thread node of current user --> add new thread id and invitation key
  // 3) update the thread node of target user --> add new thread id and invitation key
  // 4) return newly created thread
  static Future<Thread> _createPrivate1To1Thread(
    String ownerEntityId,
    String memberEntityId,
  ) async {
    Completer<Thread> completer = Completer<Thread>();

    //USERS
    final owner = await UserController.getUserIfPresent(ownerEntityId);
    final member = await UserController.getUserIfPresent(memberEntityId);

    if (member == null) {
      completer.complete(
          Thread.fromError(true, 'This user is not found on messenger'));
    } else {
      //THREAD
      Map<String, dynamic> threadMetaValues = {
        Keys.CreationDate: ServerValue.timestamp,
        Keys.Creator: ownerEntityId,
        'creator_entity_id': ownerEntityId,
        Keys.Name: '',
        Keys.Type: ThreadType.Private1to1,
        Keys.TypeV4: ThreadType.Private1to1,
        Keys.State: 'active',
      };

      Map<String, dynamic> threadDetailValues = threadMetaValues;

      Map<String, Map<String, dynamic>> threadUsersMap = {};
      threadUsersMap[ownerEntityId] = {
        Keys.Status: 'owner',
        Keys.Name: owner!.meta!.name,
      };
      threadUsersMap[memberEntityId] = {
        Keys.Status: 'member',
        Keys.Name: member.meta!.name,
      };

      Map<String, dynamic> pushableMap = {
        Keys.Details: threadDetailValues,
        Keys.Meta: threadMetaValues,
        Keys.Users: threadUsersMap,
      };

      //create Thread
      DatabaseReference threadRef = dbRef.child('threads').push();
      // DatabaseReference threadRef =
      //     dbRef.child('threads').child('${ownerEntityId}_${memberEntityId}');
      threadRef.set(pushableMap).then((value) {
        completer.complete(fetchThreadWithThreadId(threadRef.key));

        //update owner, member users's threads node
        String threadEntityId = threadRef.key;
        dbRef
            .child(Keys.Users)
            .child(ownerEntityId)
            .child(Keys.Threads)
            .child(threadEntityId)
            .set({Keys.InvitedBy: ownerEntityId});

        dbRef
            .child(Keys.Users)
            .child(memberEntityId)
            .child(Keys.Threads)
            .child(threadEntityId)
            .set({Keys.InvitedBy: ownerEntityId});
      }).onError((dynamic error, stackTrace) {
        final e = error as PlatformException;
        completer.complete(
            Thread.fromError(true, e.message ?? 'Platform exception'));
      });
    }

    return completer.future;
  }

  ///This method is used to observe the messages node of a required thread
  ///This is working fine but the problem is
  ///When we parse data whenever we call event.snapshot.value the data get disordered
  ///and orderByChild function is not working wo we get the messages in random order
  ///waiting for a fix and for the time being  i am using the below method
  static Future<StreamSubscription<Event>> listenChat(
      String threadEntityId, void onData(List<Message> messages)) async {
    StreamSubscription<Event> subscription = dbRef
        .child(Keys.Threads)
        .child(threadEntityId)
        .child('messages')
        .orderByChild('date')
        .onValue
        .listen((event) {
      if (event.snapshot == null) {
        onData(<Message>[]);
      } else {
        var snapValues = event.snapshot.value;
        if (snapValues == null) {
          onData(<Message>[]);
        } else {
          var messageList = <Message>[];

          ///when we loop through the snapshots it gives us a key with the contain map s
          ///so the map key is basically the message id
          snapValues.forEach((key, value) {
            messageList.add(
                Message.fromJsonWithId(Map<String, dynamic>.from(value), key));
          });
          onData(messageList);
        }
      }
    });

    return subscription;
  }

  ///This method observer if new data is added in the message node and when call
  ///it return messages 1 by 1 so we store those messages in a list manually and that's
  ///how we maintain the order
  ///No known issues but i am not sure about the performance, so far there is no performance issue
  ///but may be there will if the data gets too large
  static Future<StreamSubscription<Event>> listenChatBySingleMessage(
      String threadEntityId,
      String currentUserId,
      void onData(Message message),
      double deletedTimeStamp) async {
    StreamSubscription<Event> subscription = dbRef
        .child(Keys.Threads)
        .child(threadEntityId)
        .child('messages')
        .onChildAdded
        .listen((event) {
      if (event.snapshot == null) {
        onData(Message.defaultValue());
      } else {
        var snapValues = event.snapshot.value;
        if (snapValues == null) {
          onData(Message.defaultValue());
        } else {
          Message m = Message.fromJsonWithId(
            Map<String, dynamic>.from(event.snapshot.value),
            event.snapshot.key,
          );

          if (deletedTimeStamp != null && deletedTimeStamp > m.date!) return;

          ///These messages are being observed in chat view so thats why
          ///on receive check if the status of that message is unread then update the read
          ///status to seen because this will be delivered directly into the chatView

          //TODO implement break statement for better performance
          //when condition is executed break the loop for now read link will run twice
          //so no issues but when you implement group chat consider breaking loop
          m.readLink!.forEach((element) {
            if (element.entityId == currentUserId &&
                element.status != ReadType.Seen) {
              updateReadStatusAsync(
                  m.entityID!, threadEntityId, ReadType.Seen, currentUserId);
            }
          });

          onData(m);
        }
      }
    });

    return subscription;
  }

  static Future<Message> sendMessage(Message msg) async {
    Completer<Message> completer = Completer();

    final meta = <String, dynamic>{};

    ///meta map
    if (msg.meta!.type == MessageType.Text) {
      meta[Keys.MessageText] = msg.meta!.text;
      meta[Keys.type] = msg.meta!.type;
    } else if (msg.meta!.type == MessageType.Video) {
      meta[Keys.MessageVideoURL] = msg.meta!.videoUrl;
      meta['extraMap'] = msg.meta!.extraMap;
      meta[Keys.type] = msg.meta!.type;
    } else if (msg.meta!.type == MessageType.Image) {
      meta[Keys.MessageImage] = msg.meta!.fileUrl;
      meta[Keys.type] = msg.meta!.type;
    } else if (msg.meta!.type == MessageType.Audio) {
      meta[Keys.MessageAudioURL] = msg.meta!.audioUrl;
      meta[Keys.MessageAudioDuration] = msg.meta!.duration;
      meta[Keys.type] = msg.meta!.type;
    } else {
      completer.completeError('No implementation found for this type');
      return completer.future;
    }

    ///read map
    Map<String?, Map<String, dynamic>> read = {
      msg.from: {Keys.Status: ReadType.Seen},
    };

    ///reply Conversation Map
    Map<String, dynamic> replyConversation = {
      Keys.isReply: msg.replyConversation!.isReply,
      Keys.messageId: msg.replyConversation!.messageId,
      Keys.userId: msg.replyConversation!.userId,
      Keys.type: msg.replyConversation?.type,
      Keys.message: msg.replyConversation?.message,
      Keys.thumbUrl: msg.replyConversation?.video_thumbnail,
    };

    msg.to!.forEach((element) {
      read[element.toString()] = {Keys.Status: ReadType.Sent};
    });

    ///Prepare message object
    Map<String, dynamic> messageMap = {
      Keys.Date: ServerValue.timestamp,
      Keys.From: msg.from,
      Keys.Meta: meta,
      Keys.Read: read,
      Keys.replyConversation: replyConversation,
      Keys.To: msg.to,
      Keys.Type: msg.type,
      Keys.UserFirebaseId: msg.from,
    };

    ///Send message
    dbRef
        .child(Keys.Threads)
        .child(msg.threadEntityId)
        .child('messages')
        .push()
        .set(messageMap)
        .then((value) {
      log('Thread updated ${msg.threadEntityId}');
      completer.complete(Message.fromError(false, ''));
    }).onError((dynamic error, stackTrace) {
      final e = error as PlatformException;
      completer.complete(Message.fromError(true, e.message ?? ''));
    });

    return completer.future;
  }

  static Future<void> updateReadStatusAsync(
    String messageId,
    String threadKey,
    int status,
    String userKey,
  ) async {
    Completer<void> completer = Completer();

    Map<String, dynamic> values = {
      Keys.Date: ServerValue.timestamp,
      Keys.Status: status,
    };

    dbRef
        .child(Keys.Threads)
        .child(threadKey)
        .child('messages')
        .child(messageId)
        .child(Keys.Read)
        .child(userKey)
        .update(values)
        .then((value) => completer.complete())
        .onError((dynamic error, stackTrace) =>
            completer.completeError(error, stackTrace));

    return completer.future;
  }

  ///NOTE: not in use yet
  static Future<void> updateFileURL(
    String messageId,
    String threadKey,

    /// this will be the key of type [Keys.MessageImage] , [Keys.MessageVideoURL],[Keys.MessageAudioURL]
    String fileKey,

    ///this will the value that is going to be update
    String value,
  ) async {
    Completer<void> completer = Completer();
    dbRef
        .child(Keys.Threads)
        .child(threadKey)
        .child('messages')
        .child(messageId)
        .child(Keys.Meta)
        .child(fileKey)
        .set(value)
        .then((value) => completer.complete())
        .onError((dynamic error, stackTrace) =>
            completer.completeError(error, stackTrace));

    return completer.future;
  }

  static Future<void> updateTypingState(
      String threadId, String userId, String status) async {
    Completer<void> completer = Completer();

    dbRef
        .child(Keys.Threads)
        .child(threadId)
        .child(Keys.Users)
        .child(userId)
        .child('typing')
        .set(status)
        .then((value) => completer.complete());

    return completer.future;
  }

  static Future<void> deleteThread(
      String threadId, String currentUserKey) async {
    Completer<void> completer = Completer();

    dbRef
        .child(Keys.Threads)
        .child(threadId)
        .child(Keys.Users)
        .child(currentUserKey)
        .child(Keys.Deleted)
        .set(ServerValue.timestamp)
        .then((value) => completer.complete());

    return completer.future;
  }
}

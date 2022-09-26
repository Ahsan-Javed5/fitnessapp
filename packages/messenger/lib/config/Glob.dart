import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:messenger/controllers/user_controller.dart';

class Glob {
  //One instance, needs factory
  static Glob? _instance;

  static const String rootNode = '_debug';

  factory Glob() => _instance ??= Glob._();

  Glob._();

  //

  bool _threadItemListenerEnabled = true;
  String? currentUserKey;

  bool isThreadItemListenerEnabled() {
    return _threadItemListenerEnabled;
  }

  void setThreadItemListener(bool v) {
    _threadItemListenerEnabled = v;
  }

  static initMessenger(String userId, String customToken) async {
    Glob().currentUserKey = userId;

    //enable caching and set cache size
    var instance = FirebaseDatabase.instance;
    // instance.setPersistenceCacheSizeBytes(20000000);
    instance.setPersistenceEnabled(false);

    //keep the cached data synced
    // var ref = FirebaseDatabase.instance.reference().child(rootNode);
    // ref.keepSynced(true);

    if (customToken.isEmpty) return;
    if (!await authenticateUserWithCustomToken(customToken)) return;
    UserController.setUserOnline(userId);
  }

  static Future<bool> authenticateUserWithCustomToken(
      String customToken) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // final u = auth.currentUser;

    // if (u != null && u.uid == Glob().currentUserKey) return true;

    final result = await auth.signInWithCustomToken(customToken);
    return result.user?.uid != null;
  }
}

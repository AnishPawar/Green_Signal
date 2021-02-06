import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audio_cache.dart';

String token = '';

void playsound() {
  final player = AudioCache();
  player.play("Amb_1.wav");
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<String> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          playsound();
          // _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          playsound();
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          playsound();
        },
      );

      token = await _firebaseMessaging.getToken();
      _firebaseMessaging.subscribeToTopic('news');
      print("token: $token");
      //
      _initialized = true;
      return token;
    }
  }

  // String returnToken() {
  //   print("token: $token");
  //   print(_initialized);
  //   return token;
  // }
}

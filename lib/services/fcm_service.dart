import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_demo/utils/logger.dart';
import 'package:flutter/foundation.dart';

// It is recommended to define the background message handler as a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger.error(
    'FCM background message received: ${message.messageId}',
    error: message.notification?.title,
    stackTrace: StackTrace.current,
  );
}

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final ValueNotifier<RemoteMessage?> lastMessage = ValueNotifier(null);
  final ValueNotifier<NotificationSettings?> permissionSettings = ValueNotifier(null);
  final ValueNotifier<String?> fcmToken = ValueNotifier(null);

  Future<void> init() async {
    await requestPermissions();
    await _getFcmToken();
    _setupMessageHandlers();
  }

  Future<void> requestPermissions() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      permissionSettings.value = settings;
      Logger.error('FCM: User granted permission: ${settings.authorizationStatus}');
    } catch (e, s) {
      Logger.error('FCM: Failed to request permission', error: e, stackTrace: s);
    }
  }

  Future<void> _getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      fcmToken.value = token;
      Logger.error('FCM Token:', error: token);
    } catch (e, s) {
      Logger.error('FCM: Failed to get token', error: e, stackTrace: s);
    }
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger.error(
        'FCM foreground message received',
        error: message.notification?.body,
      );
      lastMessage.value = message;
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Logger.error(
          'FCM initial message received',
          error: message.notification?.body,
        );
        lastMessage.value = message;
      }
    });
  }
}

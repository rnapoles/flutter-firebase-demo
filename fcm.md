# Tutorial: Using Firebase Cloud Messaging (FCM) in a Flutter App

This tutorial provides a step-by-step guide on how to integrate Firebase Cloud Messaging into your Flutter project to receive push notifications.

---

## 1. What is Firebase Cloud Messaging?

Firebase Cloud Messaging (FCM) is a cross-platform messaging solution that lets you reliably send messages at no cost. You can send notification messages to drive user re-engagement and retention, or you can send data messages and determine what happens in your application's code.

---

## 2. Initial Project Setup

This tutorial assumes you have already connected your Flutter app to a Firebase project. If not, please follow the instructions in the main `README.md` file using the `flutterfire_cli`.

### Add FCM to your Firebase Project

While `flutterfire_cli` handles the app-side configuration, you need to ensure your Firebase project is ready for FCM.

- **For Android**: No special steps are usually needed in the Firebase console itself.
- **For iOS**: You **must** upload an Apple Push Notification service (APNs) key to your Firebase project.
  1.  In your Apple Developer account, go to **Certificates, Identifiers & Profiles > Keys**.
  2.  Create a new key with the **Apple Push Notifications service (APNs)** enabled.
  3.  Download the `.p8` key file.
  4.  In your **Firebase project console**, go to **Project Settings > Cloud Messaging**.
  5.  Under the **"Apple app configuration"** section, upload the `.p8` key file you just downloaded. You will also need to provide your Key ID and Team ID (both found in your Apple Developer account).

---

## 3. Flutter App Integration

### Add the Dependency

Add the `firebase_messaging` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^...
  firebase_messaging: ^15.0.1 # Use the latest version
```

Then, install the package by running `flutter pub get`.

### Platform-Specific Configuration

The `flutterfire configure` command should handle most of this, but it's good to know what's required.

- **Android**: No additional setup is typically required after running `flutterfire configure`.
- **iOS**: You must enable Push Notifications in Xcode.
  1.  Open your project's `ios/Runner.xcworkspace` file in Xcode.
  2.  Select the `Runner` target.
  3.  Go to the **"Signing & Capabilities"** tab.
  4.  Click **"+ Capability"** and add **"Push Notifications"**.
  5.  You also need to enable background modes for receiving background notifications. Click **"+ Capability"**, select **"Background Modes"**, and check the boxes for **"Background fetch"** and **"Remote notifications"**.

---

## 4. Implementing FCM in Your App

The code in this project's `lib/services/fcm_service.dart` and `lib/screens/fcm_screen.dart` provides a complete, working example. Here's a breakdown of the key concepts.

### Initialization

You need to initialize the service and set up handlers when your app starts or when the FCM screen is loaded. In this project, we do it in the `initState` of `FcmScreen`.

```dart
// In your screen's state...
final FcmService _fcmService = FcmService();

@override
void initState() {
  super.initState();
  _fcmService.init();
}
```

### Requesting Permissions

On iOS and Android 13+, you must ask the user for permission to show notifications.

```dart
// In FcmService
Future<void> requestPermissions() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}
```

### Getting the FCM Token

Each device has a unique token that you can use to send messages to it directly.

```dart
// In FcmService
Future<String?> _getFcmToken() async {
  return await FirebaseMessaging.instance.getToken();
}
```
You can see this token displayed on the FCM Demo screen in the app.

### Handling Messages

There are three states in which your app can receive a message:

1.  **Foreground**: When your app is open and visible. You can listen to the `FirebaseMessaging.onMessage` stream. This is useful for showing an in-app notification or updating the UI.

    ```dart
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // Update UI, show a local notification, etc.
    });
    ```

2.  **Background**: When your app is in the background (but not terminated). You define a top-level function to handle these messages.

    ```dart
    @pragma('vm:entry-point')
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print("Handling a background message: ${message.messageId}");
    }

    // In your setup code:
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    ```

3.  **Terminated**: When the app was completely closed and is opened by the user tapping the notification. You can check for an `initialMessage`.

    ```dart
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Navigate to a specific screen based on the message content
    }
    ```

---

## 5. Sending a Test Message

The easiest way to test your setup is by using the Firebase Console.

1.  Run the app on a physical device or an emulator with Google Play Services.
2.  Go to the **FCM Demo** screen in the app and copy the device's FCM token.
3.  In your **Firebase project console**, go to **Engage > Messaging**.
4.  Click **"Create your first campaign"** and select **"Firebase Notification messages"**.
5.  Enter a **Notification title** and **Notification text**.
6.  On the right-hand side, click **"Send test message"**.
7.  Paste the FCM token you copied from the app into the field and click **"Test"**.

You should receive the notification on your device! If the app is in the foreground, you'll see the log message and the UI on the FCM screen will update. If the app is in the background or terminated, you'll see a system notification.

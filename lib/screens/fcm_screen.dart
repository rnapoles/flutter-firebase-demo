import 'package:firebase_demo/services/fcm_service.dart';
import 'package:firebase_demo/widgets/app_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmScreen extends StatefulWidget {
  const FcmScreen({super.key});
  @override
  State<FcmScreen> createState() => _FcmScreenState();
}

class _FcmScreenState extends State<FcmScreen> {
  final FcmService _fcmService = FcmService();

  @override
  void initState() {
    super.initState();
    _fcmService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Cloud Messaging'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FCM Demo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('This screen demonstrates how to receive Firebase Cloud Messages.'),
              const SizedBox(height: 20),

              ValueListenableBuilder<NotificationSettings?>(
                valueListenable: _fcmService.permissionSettings,
                builder: (context, settings, child) {
                  return Text('Permission Status: ${settings?.authorizationStatus.name ?? 'Not Determined'}');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fcmService.requestPermissions,
                child: const Text('Request Permissions Manually'),
              ),
              const Divider(height: 40),

              const Text('Device FCM Token:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ValueListenableBuilder<String?>(
                valueListenable: _fcmService.fcmToken,
                builder: (context, token, child) {
                  if (token == null) return const Text('Loading token...');
                  return Row(
                    children: [
                      Expanded(child: SelectableText(token)),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: token));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('FCM Token copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 40),

              const Text('Last Received Message:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ValueListenableBuilder<RemoteMessage?>(
                valueListenable: _fcmService.lastMessage,
                builder: (context, message, child) {
                  if (message == null) return const Text('No message received yet.');
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(message.notification?.title ?? 'No Title'),
                      subtitle: Text(message.notification?.body ?? 'No Body'),
                      trailing: const Icon(Icons.message),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Firebase Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Books & Authors Management',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Counter'),
            onTap: () {
              // Avoid navigating to the same page
              if (ModalRoute.of(context)!.settings.name != '/') {
                Navigator.of(context).pushReplacementNamed('/');
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Books & Authors'),
            onTap: () {
              // Avoid navigating to the same page
              if (ModalRoute.of(context)!.settings.name != '/books-authors') {
                Navigator.of(context).pushReplacementNamed('/books-authors');
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('FCM Demo'),
            onTap: () {
              // Avoid navigating to the same page
              if (ModalRoute.of(context)!.settings.name != '/fcm') {
                Navigator.of(context).pushReplacementNamed('/fcm');
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

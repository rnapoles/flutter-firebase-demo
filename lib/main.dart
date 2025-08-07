import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_demo/screens/counter_screen.dart';
import 'package:firebase_demo/screens/books_authors_screen.dart';
import 'package:firebase_demo/screens/fcm_screen.dart';
import 'package:firebase_demo/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e, s) {
    Logger.error(
      'FATAL: Firebase initialization failed',
      error: e,
      stackTrace: s,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CounterScreen(),
        '/books-authors': (context) => const BooksAuthorsScreen(),
        '/fcm': (context) => const FcmScreen(),
      },
    );
  }
}

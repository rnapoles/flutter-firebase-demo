import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_demo/widgets/app_drawer.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final DocumentReference _counterRef =
      FirebaseFirestore.instance.collection('counters').doc('default_counter');

  void _incrementCounter() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(_counterRef);
      if (!snapshot.exists) {
        transaction.set(_counterRef, {'count': 1});
      } else {
        final newCount = snapshot.get('count') + 1;
        transaction.update(_counterRef, {'count': newCount});
      }
    }).catchError((error) {
      print("Failed to update counter: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: _counterRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text(
                    '0',
                    style: TextStyle(fontSize: 24),
                  );
                }

                final count = snapshot.data!.get('count');

                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

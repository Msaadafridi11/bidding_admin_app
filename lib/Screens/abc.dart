import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Abc extends StatefulWidget {
  const Abc({super.key});

  @override
  State<Abc> createState() => _AbcState();
}

class _AbcState extends State<Abc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abc Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('connection_test')
                        .add({
                      'status': 'ok',
                      'time': Timestamp.now(),
                    });
                    debugPrint('✅ FIRESTORE CONNECTED');
                  } catch (e) {
                    debugPrint('❌ FIRESTORE ERROR: $e');
                  }
                },
                child: const Text('Test Firestore'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
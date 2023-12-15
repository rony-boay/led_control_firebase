import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LED Status',
      home: LEDStatusScreen(),
    );
  }
}

class LEDStatusScreen extends StatefulWidget {
  const LEDStatusScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LEDStatusScreenState createState() => _LEDStatusScreenState();
}

class _LEDStatusScreenState extends State<LEDStatusScreen> {
  late DatabaseReference _ledStatusRef;
  bool _ledStatus = false;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _ledStatusRef = FirebaseDatabase.instance.reference().child('ledStatus');
    _ledStatusRef.onValue.listen((event) {
      setState(() {
        _ledStatus = (event.snapshot.value as bool);
      });
    });
  }

  @override
  void dispose() {
    _ledStatusRef.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LED Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LED is ${_ledStatus ? 'On' : 'Off'}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle LED status when button is pressed
                _ledStatusRef.set(!_ledStatus);
              },
              child: Text(_ledStatus ? 'Turn Off LED' : 'Turn On LED'),
            ),
          ],
        ),
      ),
    );
  }
}

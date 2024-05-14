import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawrtal/firebase_options.dart';

void main()  async {
  
  // Firebase Initialisation
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Main app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawrtal/firebase_options.dart';
import 'package:pawrtal/screens/wrapper.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:pawrtal/models/myuser.dart';

void main()  async {
  
  // Firebase Initialisation
  WidgetsFlutterBinding.ensureInitialized();
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
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

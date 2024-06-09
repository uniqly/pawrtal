import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawrtal/firebase_options.dart';
import 'package:pawrtal/screens/authenticate/authenticate.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:pawrtal/models/myuser.dart';
import 'package:pawrtal/screens/home/home.dart';
import 'package:pawrtal/screens/onboarding/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Authenticate(), // Modify as necessary
          '/home': (context) => const Home(),
          '/welcome': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            final username = args['username'] as String;
            return Welcome(username: username);
          },
        },
      ),
    );
  }
}

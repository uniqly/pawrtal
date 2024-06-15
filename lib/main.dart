import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/firebase_options.dart';
import 'package:pawrtal/views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawrtal/screens/authenticate/authenticate.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/views/profile/profile.dart';
import 'package:provider/provider.dart' as provider;
import 'package:pawrtal/models/myuser.dart';
import 'package:pawrtal/screens/onboarding/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Main app
  runApp( 
    // enable riverpod
    const ProviderScope(
      child: MainApp()
    )

  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Authenticate(), // Modify as necessary
          '/home': (context) => const MainView(),
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

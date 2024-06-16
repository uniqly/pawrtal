import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/firebase_options.dart';
import 'package:pawrtal/views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawrtal/views/auth/authenticate.dart';
import 'package:pawrtal/services/auth.dart';

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

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final auth = ref.watch(authUserProvider);
    return const MaterialApp( 
      /*
      home: auth.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) { 
          log('$stack');
          return Text('error: $err');
        },
        data: (authUser) {
          log('authstate: ${authUser != null}');
          return authUser != null ? const MainView() : const Authenticate();
        }
      )
      */
      home: MainView(),
    );
    /*
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
    */
  }
}

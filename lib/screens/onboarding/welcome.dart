import 'package:flutter/material.dart';
import 'package:pawrtal/shared/loading.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: const Color.fromRGBO(254, 247, 255, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Center(
                  child: Image.asset('assets/app/pawrtal_logo_full.png'),
                ),
                const SizedBox(height: 50.0),
              ]
            ),
          )
        )
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Welcome extends StatefulWidget {
  final String? username;
  const Welcome({super.key, required this.username});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final controller = PageController()
;
  bool loading = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: [
            Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 200.0),
                Text(
                  'Welcome ${widget.username ?? 'username'}',
                  textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0.05,
                    ) ,
                ), // Display the welcome message
                const SizedBox(height: 10.0),
                Center(
                  child: Image.asset(
                    'assets/app/pawrtal_icon.png',
                    width: 300,
                    height: 300,
                    ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the onboarding process
                    // Navigator.push()
                  },
                child: const Text('Get Started'),
                )
              ]
            ),
          ),
          Container(
            color:Colors.purple,
            child: const Center(child: Text('Page 2'))
          ),
          Container(
            color:Colors.blue,
            child: const Center(child: Text('Page 3'))
          ),
          ]
          )
    ),
    bottomSheet: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20 ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: const Text('Skip'),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            }
          ),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
            count: 3,
          ),
          ),
          TextButton(
            child: const Text('Next'),
            onPressed: () {}
          ),
        ]
      ))
    );
  }
}
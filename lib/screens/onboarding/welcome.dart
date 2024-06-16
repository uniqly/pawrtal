import 'package:flutter/material.dart';
import 'package:pawrtal/main.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:pawrtal/views/main_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Welcome extends StatefulWidget {
  final String? username;
  const Welcome({super.key, required this.username});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final controller = PageController();
  bool loading = false;
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            _buildPageContent(
              image: 'assets/app/people_with_pets.jpg',
              title: 'Welcome to Pawrtal, ${widget.username ?? 'username'}',
              body: 'Pawrtal is a social media platform for pet lovers like you. Connect with other pet owners, share adorable photos and videos of your pets, and discover pet-related events and activities in your area.',
            ),
            _buildPageContent(
              image: 'assets/app/people-playing-with-their-pets.png', // Change this to the actual image path for page 2
              title: 'Share and Discover',
              body: 'Share your pet\'s special moments with our community. From playful puppies to curious cats, Pawrtal lets you showcase your furry friends and discover others who share your passion for pets.',
            ),
            _buildPageContent(
              image: 'assets/app/people_walking_dog.jpg', // Change this to the actual image path for page 3
              title: 'Join the Pawrtal Community',
              body: 'Join the Pawrtal community today! Create an account to start connecting with pet lovers, finding local events, and getting expert advice on pet care. Your adventure with your pet begins here.',
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Skip'),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            isLastPage 
            ? TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainApp()));
                },
                child: const Text('Get Started'),
              )
            : TextButton(
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({required String image, required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0),
          Center(
            child: Image.asset(
              image,
              width: 300,
              height: 300,
            ),
          ),
          const SizedBox(height: 20.0),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pawrtal/shared/constants.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {

  const ForgetPassword({super.key});
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool loading = false;

  // text field state
  String email = '';

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
                  child: Image.asset('assets/app/pawrtal.png'),
                ),
                Center(
                  child: Image.asset(
                    'assets/app/reset-password.png',
                    height: 100.0,
                    fit: BoxFit.contain,
                  )
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Forgot your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.05,
                  )
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Enter your email below to receive a password reset link to get back into your account.',
                  textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email), // Add the email icon
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(height:20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 206, 199, 224),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        } catch (e) {
                          print('exception->$e');
                          return null;
                        }
                      },
                      child: const Text(
                        'Reset password',              
                      ),
                    ),
                    const SizedBox(width: 10), // Add a gap of 10 pixels
                    ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 206, 199, 224),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to login',
                  ),
                ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/main.dart';
import 'package:pawrtal/views/auth/forget_password.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/shared/constants.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawrtal/views/main_view.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String username = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: const Color.fromRGBO(254, 247, 255, 1),
      body: SingleChildScrollView(
        child:Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Center(
                  child: Image.asset('assets/app/pawrtal_logo_full.png'),
                ),
                const SizedBox(height: 50.0),
                const Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.05,
                  ),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.email), // Add the email icon
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                  onChanged: (val) {
                    setState(() => username = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    ),
                  obscureText: true,
                  validator: (val) => val!.length < 8 ? 'Enter a password 8+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF65558F), // background color
                    ),
                    child: const Text(
                      'Sign in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFEF7FF),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 0.07,
                        letterSpacing: 0.50,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        //dynamic result = await _auth.signInWithUsernameAndPassword(username, password);
                        final result = await AuthService.signInWithUsernameAndPassword(username, password);
                        if (result == null) {
                          setState(() {
                            error = 'Could not sign in with those credentials';
                            loading = false;
                          });
                        } else {
                          loading = false;
                          // Navigate to home screen
                          if (context.mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()));
                          }
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: Colors.grey[600], // Change the color to match your design
                          thickness: 1.0, // Change the thickness if needed
                        ),
                      ),
                    ),
                    const Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 0.05,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: Colors.grey[600], // Change the color to match your design
                          thickness: 1.0, // Change the thickness if needed
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // background color
                    ),
                    icon: Image.asset(
                      'assets/app/google_logo_icon.png',
                      height: 24,
                      width: 24,
                  ), // Google icon
                    onPressed: () async {
                      setState(() => loading = true);
                      log('Initiating Google sign-in');
                      UserCredential? result = await AuthService.signInWithGoogle();
                      log('Google SignIn result: $result');
                      if (result == null) {
                      setState(() {
                        error = 'Could not sign in with Google';
                        loading = false;
                      });
                      } else {
                        loading = false;
                        log('Signed in with Google: ${result.user?.email}');
                        // Navigate to home screen
                        if (context.mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()));
                        }
                      }
                    },
                    label: const Text(
                      'Sign in with Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF65558F),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 0.07,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        widget.toggleView(); // Toggle to the registration screen
                      },
                      child: const Text('Create account'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgetPassword()),
                        );
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
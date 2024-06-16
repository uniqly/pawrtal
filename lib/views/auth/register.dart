import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/screens/onboarding/welcome.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/shared/constants.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      String email = _emailController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      try {
        dynamic result = await AuthService.registerWithEmailandPassword(email, username, password);
        if (result == null) {
          setState(() {
            error = 'Registration failed. Please try again.';
            loading = false;
          });
        } else {
          if (mounted) {
            log('reg');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome(username: username)));
          }
        }
      } catch (e) {
        log('Error registering user: $e');
        if (mounted) {
          setState(() {
            error = 'Registration failed. Please try again.';
            loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading 
      ? const Loading()
      : Scaffold(
          backgroundColor: const Color.fromRGBO(254, 247, 255, 1),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/app/pawrtal.png'),
                    ),
                    const SizedBox(height: 50.0),
                    const Text(
                      'Register now!',
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
                      controller: _emailController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 8 ? 'Enter a password 8+ chars long' : null,
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF65558F),
                        ),
                        onPressed: _register,
                        child: const Text(
                          'Register',
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
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(
                              color: Colors.grey[600],
                              thickness: 1.0,
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
                              color: Colors.grey[600],
                              thickness: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        icon: Image.asset(
                          'assets/app/google_logo_icon.png',
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () async {
                          setState(() => loading = true);
                          UserCredential? result = await AuthService.signInWithGoogle();
                          if (result == null) {
                            setState(() {
                              error = 'Could not sign in with Google';
                              loading = false;
                            });
                          } else {
                            log('Signed in with Google: ${result.user?.email}');
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
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Already have an account?'),
                        TextButton.icon(
                          icon: const Icon(Icons.person),
                          label: const Text('Sign in'),
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
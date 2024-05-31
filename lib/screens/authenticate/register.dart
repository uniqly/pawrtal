import 'package:flutter/material.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/shared/constants.dart';
import 'package:pawrtal/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
        body: Container(
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
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF65558F),
                  ),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailandPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = 'Please supply a valid email';
                          loading = false;
                        });
                      }
                    }
                  },
                ),
                ),
                const SizedBox(height: 5.0),
                const Text('Or'),
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
                 ), // Google icon // Google icon
                  onPressed: () {},
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
                  const Text(
                    'Already have an account?'
                  ),
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
      );
  }
}
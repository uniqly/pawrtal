import 'package:flutter/material.dart';
import 'package:pawrtal/main.dart';
import 'package:pawrtal/views/auth/authenticate.dart';
import 'package:pawrtal/screens/onboarding/welcome.dart';
import 'package:pawrtal/views/main_view.dart';
import 'package:provider/provider.dart';
import 'package:pawrtal/models/myuser.dart';

class Wrapper extends StatelessWidget {
  final bool isNewUser;

  const Wrapper({super.key, required this.isNewUser});

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<MyUser?>(context);

    // Return either home, welcome, or authenticate widget
    if (customer == null) {
      return const Authenticate();
    } else if (isNewUser) {
      return Welcome(username: customer.username ?? '');
    } else {
      return const MainApp();
    }
  }
}
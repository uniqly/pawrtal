import 'package:flutter/material.dart';
import 'package:pawrtal/screens/authenticate/authenticate.dart';
import 'package:pawrtal/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:pawrtal/models/myuser.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final customer = Provider.of<MyUser?>(context);

    // return either home or authenticate widget
    if (customer ==  null) {
      return const Authenticate();
    } else {
      return const Home();
    }
  }
}
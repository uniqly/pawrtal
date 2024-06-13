import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Color.fromRGBO(234, 221, 255, 1),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purple, width: 2.0)
  ),             
);
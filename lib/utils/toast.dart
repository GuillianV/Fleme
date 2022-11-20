import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

simpleToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 101, 101, 101),
      textColor: Colors.white,
      fontSize: 16.0);
}

import 'package:flutter/material.dart';

List<BoxShadow> shadowBlack() {
  return [
    const BoxShadow(
        color: Colors.black87,
        offset: Offset(2, 2),
        blurRadius: 10,
        spreadRadius: 1),
    const BoxShadow(
        color: Colors.white,
        offset: Offset(-2, -2),
        blurRadius: 10,
        spreadRadius: 1)
  ];
}

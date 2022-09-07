import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/picture.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/views/camera_view.dart';
import 'package:fleme/views/homepage_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Picture>(
          create: (_) => Picture(),
        ),
        ChangeNotifierProvider<Recognizers>(
          create: (_) => Recognizers(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fleme'),
    );
  }
}

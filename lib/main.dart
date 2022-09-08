import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/picture.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/views/camera_view.dart';
import 'package:fleme/views/homepage_view.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:fleme/views/image_recognized_view.dart';
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
      routes: {
        '/': (context) => const MyHomePage(title: 'Fleme'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/image_filter') {
          final value = settings.arguments as int;
          return MaterialPageRoute(
              builder: (_) => ImageFilter(recognizedId: value));
        } else if (settings.name == '/image_recognized') {
          final value = settings.arguments as int;
          return MaterialPageRoute(
              builder: (_) => ImageRecognized(recognizedId: value));
        }
        else if (settings.name == '/camera') {
          final value = settings.arguments as List<CameraDescription>;
          return MaterialPageRoute(
              builder: (_) => CameraPage(cameras: value));
        }


        return null;
      },
    );
  }
}

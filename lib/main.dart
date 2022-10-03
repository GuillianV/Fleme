import 'package:fleme/models/providers/picture_provider.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/theme/theme.dart';
import 'package:fleme/views/homepage_view.dart';
import 'package:fleme/views/filter_view.dart';
import 'package:fleme/views/recognized_view.dart';
import 'package:fleme/views/text_block_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

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
    ThemeMode themeMode = ThemeMode.dark;

    return MaterialApp(
      title: 'Fleme',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme(ThemeMode.light),
      darkTheme: theme(ThemeMode.dark),
      routes: {
        '/': (context) => const MyHomePage(title: 'Fleme'),
      },
      onGenerateRoute: (settings) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        if (settings.name == '/image_filter') {
          final value = settings.arguments as int;
          return MaterialPageRoute(
              builder: (_) => ImageFilter(recognizedId: value));
        } else if (settings.name == '/image_recognized') {
          final value = settings.arguments as int;
          return MaterialPageRoute(
              builder: (_) => ImageRecognized(recognizedId: value));
        } else if (settings.name == '/textBlock_edit') {
          Map data = settings.arguments! as Map;
          final recognizedId = data["recognizedId"] as int;
          final textBlockId = data["textBlockId"] as int;
          return MaterialPageRoute(
              builder: (_) => TextBlockEdit(
                  recognizedId: recognizedId, textBlockId: textBlockId));
        }

        return null;
      },
    );
  }
}

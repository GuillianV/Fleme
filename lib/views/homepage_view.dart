import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/page/list_page.dart';
import 'package:fleme/page/scan_page.dart';
import 'package:fleme/page/settings_page.dart';
import 'package:fleme/widgets/images_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeActual = Theme.of(context);

    Brightness brightnessIcons = themeActual.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: themeActual.backgroundColor,
        statusBarBrightness: brightnessIcons,
        statusBarIconBrightness: brightnessIcons,
        systemNavigationBarColor: themeActual.backgroundColor,
        systemNavigationBarIconBrightness: brightnessIcons));

    if (_pageController == null) exit(1);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: const <Widget>[ListPage(), ScanPage(), SettingsPage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Mon Texte', icon: Icon(Icons.text_fields)),
          BottomNavigationBarItem(
              label: 'Scan', icon: Icon(Icons.document_scanner)),
          BottomNavigationBarItem(
              label: 'Parametres', icon: Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras()
              .then((value) =>
                  Navigator.pushNamed(context, '/camera', arguments: value))
              .catchError((onError) => Navigator.pop(context));
        },
        tooltip: 'Scan text',
        child: const Icon(Icons.image),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}

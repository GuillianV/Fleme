import 'package:fleme/main.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    themeMode = MyApp.of(context).getTheme();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsetsGeometry.lerp(
                const EdgeInsets.all(10), const EdgeInsets.all(10), 10),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Parametres',
                style: theme.textTheme.headline2,
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsGeometry.lerp(
                const EdgeInsets.all(10), const EdgeInsets.all(10), 10),
            child: Text(
              'Theme Mode',
              style: theme.textTheme.headline6,
            ),
          ),
          Container(
            child: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: ((value) {
                setState(() {
                  if (value) {
                    themeMode = ThemeMode.dark;
                  } else {
                    themeMode = ThemeMode.light;
                  }
                  MyApp.of(context).changeTheme(themeMode);
                });
              }),
            ),
          ),
        ],
      ),
    );
  }
}

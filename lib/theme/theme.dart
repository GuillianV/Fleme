import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme(ThemeMode themeMode) {
  late Color primaryColor;
  late Color secondaryColor;
  late Color backgroundColor;
  late Brightness brightness;
  late ColorScheme colorScheme;

  String fontFamily = GoogleFonts.poppins().fontFamily ?? '';

  if (ThemeMode.light == themeMode) {
    primaryColor = Color.fromARGB(255, 54, 143, 139);
    secondaryColor = Color.fromARGB(255, 34, 34, 34);
    backgroundColor = const Color.fromARGB(255, 241, 237, 238);

    brightness = Brightness.light;
    colorScheme = ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    );
  } else {
    primaryColor = Color.fromARGB(255, 54, 143, 139);
    secondaryColor = const Color.fromARGB(255, 241, 237, 238);
    backgroundColor = const Color.fromARGB(255, 34, 34, 34);

    brightness = Brightness.dark;
    colorScheme = ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    );
  }

  return ThemeData(
    // Define the default brightness and colors.
    brightness: brightness,
    primaryColor: primaryColor,
    colorScheme: colorScheme,
    fontFamily: fontFamily,
    backgroundColor: backgroundColor,
    canvasColor: backgroundColor,

    textTheme: TextTheme(
      headline1: const TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.w700,
      ),
      headline2: const TextStyle(fontSize: 64.0, fontWeight: FontWeight.w600),
      headline3: const TextStyle(fontSize: 56.0, fontWeight: FontWeight.w500),
      headline4: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.w400),
      headline5: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.w300),
      headline6: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w300),
      bodyText1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontFamily: fontFamily),
      bodyText2: TextStyle(
        fontSize: 14.0,
        fontFamily: fontFamily,
      ),
    ).apply(bodyColor: secondaryColor, displayColor: primaryColor),
  );
}

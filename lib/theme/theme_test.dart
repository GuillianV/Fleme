import 'package:flutter/material.dart';

List<Widget> themeTest(BuildContext context) {
  String text = "Text Test 104";

  return [
    Text(
      text,
      style: Theme.of(context).textTheme.headline1,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.headline2,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.headline3,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.headline4,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.headline5,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.headline6,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.bodyText1,
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.bodyText2,
    ),
  ];
}

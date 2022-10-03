import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlurTitle extends StatelessWidget {
  const BlurTitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Center(
          child: Text(text,
              style: GoogleFonts.poppins(
                  textStyle: theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.w700, color: Colors.white70))),
        ),
      ),
    );
  }
}

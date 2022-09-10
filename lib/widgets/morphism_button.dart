import 'package:fleme/utils/shadow_black.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MorphismButton extends StatefulWidget {
  const MorphismButton(
      {super.key,
      required this.textValue,
      required this.onTaped,
      this.icon,
      this.fontSize,
      this.width,
      this.height});

  final String textValue;
  final Function onTaped;
  final double? width;
  final double? height;
  final double? fontSize;
  final Icon? icon;

  @override
  State<MorphismButton> createState() => _MorphismButtonState();
}

class _MorphismButtonState extends State<MorphismButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          _isPressed = !_isPressed;
          widget.onTaped();
        })
      },
      child: Container(
        width: widget.width ?? 100,
        height: widget.height ?? 50,
        decoration: !_isPressed
            ? BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(50),
                boxShadow: shadowBlack())
            : BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(50),
                boxShadow: shadowBlack()),
        child: Center(
            child: widget.icon != null
                ? widget.icon!
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.textValue,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: widget.fontSize ?? 15))),
                  )),
      ),
    );
  }
}

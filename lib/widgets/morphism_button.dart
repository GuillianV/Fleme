import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MorphismButton extends StatefulWidget {
  const MorphismButton(
      {super.key,
      required this.textValue,
      required this.onTaped,
      this.icon,
      this.fontSize});

  final String textValue;
  final Function onTaped;
  final double? fontSize;
  final Icon? icon;

  @override
  State<MorphismButton> createState() => _MorphismButtonState();
}

class _MorphismButtonState extends State<MorphismButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => {
        setState(() {
          _isPressed = !_isPressed;
          widget.onTaped();
        })
      },
      child: Container(
        width: 100,
        height: 50,
        child: Center(
            child: widget.icon != null
                ? widget.icon!
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.textValue,
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: widget.fontSize ?? 15))),
                  )),
        decoration: !_isPressed
            ? BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400]!,
                        offset: const Offset(4, 4),
                        blurRadius: 15,
                        spreadRadius: 1),
                    const BoxShadow(
                        color: Colors.white,
                        offset: const Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 1)
                  ])
            : null,
      ),
    );
  }
}

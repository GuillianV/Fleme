import 'package:fleme/theme/box_shadow.dart';
import 'package:flutter/material.dart';

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
    ThemeData themeActual = Theme.of(context);

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
                color: themeActual.colorScheme.secondary,
                borderRadius: BorderRadius.circular(5),
                boxShadow: box_shadow(context))
            : BoxDecoration(
                color: themeActual.colorScheme.secondary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
                boxShadow: box_shadow(context)),
        child: Center(
            child: widget.icon != null
                ? widget.icon!
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.textValue,
                        textAlign: TextAlign.center,
                        style: themeActual.textTheme.headline5),
                  )),
      ),
    );
  }
}

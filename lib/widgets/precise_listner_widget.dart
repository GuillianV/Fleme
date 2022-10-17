import 'package:flutter/material.dart';

class PreciseListener extends StatefulWidget {
  PreciseListener(
      {super.key,
      required this.child,
      this.onSimpleTaped(pointerDownEvent, pointerUpEvent)?});

  final Widget child;
  late Function(PointerDownEvent, PointerUpEvent)? onSimpleTaped;

  @override
  State<PreciseListener> createState() => _PreciseListenerState();
}

class _PreciseListenerState extends State<PreciseListener> {
  int timeForSimpleTap = 500;
  bool isDown = false;
  bool isUp = false;

  late PointerDownEvent downEvent;
  late PointerUpEvent upEvent;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        isDown = true;
        isUp = false;
        downEvent = event;
        onPointerDown();
      },
      onPointerUp: (event) {
        isDown = false;
        isUp = true;
        upEvent = event;
      },
      child: widget.child,
    );
  }

  void onPointerDown() async {
    Future.delayed(Duration(milliseconds: timeForSimpleTap), () {
      if (isUp) {
        if (widget.onSimpleTaped != null) {
          widget.onSimpleTaped!(downEvent, upEvent);
        }
      }
    });
  }
}

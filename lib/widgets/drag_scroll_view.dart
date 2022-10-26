import 'dart:math';

import 'package:fleme/views/filter_view.dart';
import 'package:flutter/material.dart';

class DragScrollView extends StatefulWidget {
  DragScrollView(
      {super.key,
      required this.widgetViewportKey,
      required this.enableDrag,
      required this.child,
      this.dragSpeed,
      this.dragDistance});

  final GlobalKey widgetViewportKey;
  final bool enableDrag;
  final Widget child;
  double? dragSpeed;
  double? dragDistance;

  @override
  State<DragScrollView> createState() => _DragScrollViewState();
}

class _DragScrollViewState extends State<DragScrollView> {
  ScrollController scrollController = ScrollController();
  double widgetTragetTopPosition = 0;
  double widgetTragetBottomPosition = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double safePadding = MediaQuery.of(context).padding.top;

    return Listener(
        onPointerMove: (PointerMoveEvent event) {
          if (!widget.enableDrag) return;

          RenderBox render = widget.widgetViewportKey.currentContext
              ?.findRenderObject() as RenderBox;
          Offset position = render.localToGlobal(Offset.zero);
          double topY = position.dy; // top positio n of the widget
          double bottomY =
              topY + render.size.height; // bottom position of the widget
          double moveDistance = widget.dragSpeed ?? 4;

          double detectedRange = widget.dragDistance ?? 150;
          if (event.position.dy < topY + detectedRange + safePadding &&
              scrollController.position.pixels >=
                  scrollController.position.minScrollExtent) {
            var to = scrollController.offset - moveDistance;
            to = (to < 0) ? 0 : to;
            scrollController.jumpTo(to);
          }
          if (event.position.dy > bottomY - detectedRange &&
              scrollController.position.pixels <=
                  scrollController.position.maxScrollExtent) {
            scrollController.jumpTo(scrollController.offset + moveDistance);
          }

          setState(() {
            widgetTragetTopPosition =
                scrollController.position.pixels + safePadding;
            widgetTragetBottomPosition =
                scrollController.position.maxScrollExtent -
                    scrollController.position.pixels;
          });
        },
        child: SingleChildScrollView(
            controller: scrollController,
            physics: widget.enableDrag
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                widget.child,
                Positioned(
                    left: 0,
                    top: widgetTragetTopPosition,
                    width: width,
                    child: DragIndicator(
                        rotated: false,
                        enableDrag: widget.enableDrag,
                        dragDistance: widget.dragDistance ?? 150)),
                Positioned(
                  left: 0,
                  // top: widgetTragetBottomPosition,
                  width: width,
                  bottom: widgetTragetBottomPosition,

                  child: DragIndicator(
                      rotated: true,
                      enableDrag: widget.enableDrag,
                      dragDistance: widget.dragDistance ?? 150),
                ),
              ],
            )));
  }
}

class DragIndicator extends StatefulWidget {
  const DragIndicator(
      {super.key,
      required this.enableDrag,
      required this.dragDistance,
      required this.rotated});

  final bool enableDrag;
  final double dragDistance;
  final bool rotated;
  @override
  State<DragIndicator> createState() => _DragIndicatorState();
}

class _DragIndicatorState extends State<DragIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 150),
        vsync: this)
      ..addListener(() => setState(() {
            if (_animationController.value >= 1) _animationController.reverse();
            if (_animationController.value <= 0) _animationController.forward();
          }));
    _animationController.forward();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Transform.translate(
      offset: widget.rotated ? const Offset(0, 1) : const Offset(0, -1),
      child: Transform.rotate(
        angle: widget.rotated ? -pi : 0,
        child: AnimatedContainer(
            clipBehavior: Clip.hardEdge,
            height: widget.enableDrag ? widget.dragDistance : 0,
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                border: Border.all(color: themeData.colorScheme.primary),
                color: themeData.colorScheme.secondary.withOpacity(0.8)),
            child: Transform.translate(
              offset: Offset(0, -_animationController.value * 10),
              child: Center(
                child: Icon(
                  Icons.arrow_drop_up_rounded,
                  color: themeData.colorScheme.background,
                  size: widget.dragDistance,
                ),
              ),
            )),
      ),
    );
  }
}

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
  ScrollPhysics physicsController = const AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    if (widget.enableDrag) {
      physicsController = const NeverScrollableScrollPhysics();
    } else {
      physicsController = const AlwaysScrollableScrollPhysics();
    }

    return Listener(
        onPointerMove: (PointerMoveEvent event) {
          if (!widget.enableDrag) return;

          RenderBox render = widget.widgetViewportKey.currentContext
              ?.findRenderObject() as RenderBox;
          Offset position = render.localToGlobal(Offset.zero);
          double topY = position.dy; // top position of the widget
          double bottomY =
              topY + render.size.height; // bottom position of the widget
          double moveDistance = widget.dragSpeed ?? 4;

          double detectedRange = widget.dragDistance ?? 150;
          if (event.position.dy < topY + detectedRange &&
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
        },
        child: SingleChildScrollView(
            controller: scrollController,
            physics: physicsController,
            child: widget.child));
  }
}

import 'package:flutter/material.dart';

class Dock extends StatefulWidget {
  final List<IconData> icons;

  const Dock({super.key, required this.icons});

  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
  late List<IconData> iconList;
  int? draggedIndex;
  double dragOffsetX = 0.0;
  double dragLastPosition = 0.0;
  double dragPosition = 0.0;

  @override
  void initState() {
    super.initState();
    iconList = widget.icons;
  }

  void _onDragStart(int index, DragStartDetails details) {
    print("onDragStart :: ${details.localPosition.dx}");
    setState(() {
      draggedIndex = index;
      dragOffsetX = details.localPosition.dx;
    });
  }

  void _onDragUpdate(int index, DragUpdateDetails details) {
    print("_onDragUpdate :: ${details.globalPosition.dx - dragOffsetX}");
    setState(() {
      dragPosition = details.globalPosition.dx - dragOffsetX;
    });
  }

  void _onDragEnd() {
    print("_onDragEnd :: ");
    setState(() {
      draggedIndex = null;
      dragPosition = 0.0;
      iconList = List.from(widget.icons);
    });
  }

  void _onDragStartVertical(int index, DragStartDetails details) {
    print("_onDragStartVertical :: ${details.localPosition.dx}");
    setState(() {
      draggedIndex = index;
      dragOffsetX = details.localPosition.dx;
      // dragOffsetY = details.localPosition.dy;
    });
  }

  void _onDragUpdateVertical(int index, DragUpdateDetails details) {
    print(
        "_onDragUpdateVertical :: ${details.globalPosition.dx - dragOffsetX}");
    setState(() {
      dragPosition = details.globalPosition.dx - dragOffsetX;
    });
  }

  void _onDragEndVertical() {
    print("_onDragEndVertical :: ");
    setState(() {
      draggedIndex = null;
      dragPosition = 0.0;
      iconList = List.from(widget.icons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Stack(
        children: List.generate(iconList.length, (index) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _calculatePosition(index),
            top: draggedIndex == index ? 200 : 270,
            child: GestureDetector(
              onHorizontalDragStart: (details) => _onDragStart(index, details),
              onHorizontalDragUpdate: (details) =>
                  _onDragUpdate(index, details),
              onVerticalDragStart: (details) =>
                  _onDragStartVertical(index, details),
              onVerticalDragUpdate: (details) =>
                  _onDragUpdateVertical(index, details),
              onHorizontalDragEnd: (_) => _onDragEnd(),
              onVerticalDragEnd: (_) => _onDragEndVertical(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: _getIconSize(index),
                height: _getIconSize(index),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconList[index],
                  color: Colors.white,
                  size: _getIconSize(index) * 0.5,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void reGenerateTheIcons(int dragIndex, int dragPosition) {
    if (dragLastPosition > 0.0 || dragLastPosition < 60.0){

    }
  }

  double _calculatePosition(int index) {
    print("Positions :: ${index * 60.0}");
    if (draggedIndex == null) {
      return index * 60.0;
    }

    if (index == draggedIndex) {
      return dragPosition;
    }

    if (dragPosition > index * 60.0 && draggedIndex! > index) {
      return index * 60.0 + 30.0;
    } else if (dragPosition < index * 60.0 && draggedIndex! < index) {
      return index * 60.0 - 30.0;
    }

    return index * 60.0;
  }

  double _getIconSize(int index) {
    if (draggedIndex == null) return 48.0;

    const double maxScale = 48.0;
    const double minScale = 48.0;
    const double proximityThreshold = 48.0;

    double distance = (dragPosition - (index * 60.0)).abs();
    double scaleFactor = (1 - (distance / proximityThreshold)).clamp(0, 1);
    return minScale + (maxScale - minScale) * scaleFactor;
  }
}

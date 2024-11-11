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
  double dragPosition = 0.0;

  @override
  void initState() {
    super.initState();
    iconList = List.from(widget.icons);
  }

  void _onDragStart(int index, DragStartDetails details) {
    setState(() {
      draggedIndex = index;
      dragOffsetX = details.localPosition.dx;
    });
  }

  void _onDragUpdate(int index, DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition.dx - dragOffsetX;
    });
  }


  void _onDragEnd() {
    setState(() {
      draggedIndex = null;
      dragPosition = 0.0;
      iconList = List.from(widget.icons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: List.generate(iconList.length, (index) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _calculatePosition(index),
            top: draggedIndex == index ? 20 : 30,
            child: GestureDetector(
              onHorizontalDragStart: (details) => _onDragStart(index, details),
              onHorizontalDragUpdate: (details) => _onDragUpdate(index, details),
              onHorizontalDragEnd: (_) => _onDragEnd(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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

  /// Calculates position based on drag or default index.
  double _calculatePosition(int index) {
    if (draggedIndex == null) {
      return index * 60.0;
    }

    if (index == draggedIndex) {
      return dragPosition;
    }

    // Adjust position for icons on left or right of the dragged icon
    if (dragPosition > index * 60.0 && draggedIndex! > index) {
      return index * 60.0 + 40.0; // Shift right
    } else if (dragPosition < index * 60.0 && draggedIndex! < index) {
      return index * 60.0 - 40.0; // Shift left
    }

    return index * 60.0;
  }

  /// Adjusts icon size based on distance to dragged icon.
  double _getIconSize(int index) {
    if (draggedIndex == null) return 48.0;

    const double maxScale = 60.0;
    const double minScale = 48.0;
    const double proximityThreshold = 80.0;

    double distance = (dragPosition - (index * 60.0)).abs();
    double scaleFactor = (1 - (distance / proximityThreshold)).clamp(0, 1);
    return minScale + (maxScale - minScale) * scaleFactor;
  }
}


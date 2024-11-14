import 'package:flutter/material.dart';


class DockMacOs extends StatefulWidget {
  final List<IconData> icons;

  const DockMacOs({super.key, required this.icons});

  @override
  State<DockMacOs> createState() => _DockMacOsState();
}

class _DockMacOsState extends State<DockMacOs> {

  late List<IconData> mainLists;
  int? dragIndex;
  double dragPos = 0.0;

  @override
  void initState() {
    super.initState();
    // copy initial icons data
    mainLists = List.from(widget.icons);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: List.generate(mainLists.length, (index) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left: _calPos(index),
            top: 40,
            child: Draggable<int>(
              data: index,
              feedback: Container(
                width: 50.0,
                height: 50.0,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  mainLists[index],
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              onDragStarted: () {
                setState(() {
                  dragIndex = index;
                  dragPos = index * 60.0;
                });
              },
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  dragIndex = null;
                });
              },
              onDragUpdate: (details) {
                setState(() {
                  dragPos = details.globalPosition.dx;
                });
              },
              onDragEnd: (details) {
                setState(() {
                  // get the final index based from drag end pos
                  int newIndex = (dragPos / 60).round().clamp(0, mainLists.length - 1);

                  // movable icon if icons being dropped at a new pos
                  if (dragIndex != null && dragIndex != newIndex) {
                    final icon = mainLists.removeAt(dragIndex!);
                    mainLists.insert(newIndex, icon);
                  }

                  dragIndex = null;
                  dragPos = 0.0;
                });
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: dragIndex == index ? 0.0 : 1.0,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    mainLists[index],
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          );
        },),
      ),
    );
  }

  // here is the method for calculate the position
  double _calPos(int index) {
    if (dragIndex == null) return index * 60.0;

    if (index == dragIndex) {
      return dragPos;
    }

    if (dragPos > index * 60.0 && dragIndex! > index) {
      return index * 60.0 + 30.0;
    } else if (dragPos < index * 60.0 && dragIndex! < index) {
      return index * 60.0 - 30.0;
    }

    return index * 60.0;
  }
}

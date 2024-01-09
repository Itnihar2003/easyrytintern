// ignore_for_file: unnecessary_null_comparison, null_check_always_fails

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class draw extends StatefulWidget {
  const draw({super.key});

  @override
  _drawState createState() => _drawState();
}

class _drawState extends State<draw> {
  // Flag to track whether the keyboard is open
  bool isKeyboardOpen = false;
  bool isDrawingMode = false;
  bool isbold = false;
  bool isitalic = false;
  bool isunderline = false;
  File? selectedImage;
  String? selectedText;
  int _selectedIndex = 0;
  Color selectedColor = Colors.black;
  double eraserSize = 20.0; // Default eraser size
  double strokeWidth = 5;
  bool isErasing = false;
  List<DrawingPoint> drawingPoints = [];
  List<Color> colors = [
    const Color(0xffFF0101),
    const Color(0xff8FFF01),
    const Color(0xff05FFC3),
    const Color(0xff01D1FF),
    const Color(0xff9E01FF)
  ];
  Color selectedBackgroundColor = const Color(0xFF9D85DC).withOpacity(0.6);

  void openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Background Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedBackgroundColor,
              onColorChanged: (color) {
                selectedBackgroundColor = color; // Update the color here
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void openColorPickerForDraw(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose  Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color; // Update the color here
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void openPenOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 225,
              child: Column(
                children: <Widget>[
                  if (_selectedIndex != 2) // Show only when not in Eraser mode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: List.generate(
                            colors.length,
                            (index) => _buildColorChose(colors[index]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openColorPickerForDraw(context);
                          },
                          child:
                              Image.asset('assets/3notescreen/Group 305.png'),
                        )
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        const Text("Size:"),
                        SizedBox(
                          width: 250,
                          child: Slider(
                            min: 0,
                            max: 100,
                            activeColor: _selectedIndex == 2
                                ? Colors.red
                                : const Color(0xff9D85DC),
                            value:
                                _selectedIndex == 2 ? eraserSize : strokeWidth,
                            onChanged: (val) {
                              setState(() {
                                if (_selectedIndex == 2) {
                                  eraserSize =
                                      val; // Set eraser size when in eraser mode
                                } else {
                                  strokeWidth =
                                      val; // Set stroke width when not in eraser mode
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 29,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          child: Text(
                            _selectedIndex == 2 ? eraserSize.toStringAsFixed(0) : strokeWidth.toStringAsFixed(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Method to switch between drawing and eraser modes.
  void toggleErasing() {
    setState(() {
      isErasing = !isErasing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: InkWell(
          onTap: () {}, child: Image.asset('assets/2notescreen/add.png')),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.draw,
                  color: Colors.black,
                  size: 30,
                ),
                label: 'Pen',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.picture_in_picture,
                  color: Colors.black,
                  size: 30,
                ),
                label: 'Background',
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2; // Select Eraser
                        openPenOptions(context); // Open eraser size options
                      });
                    },
                    child: Image.asset('assets/3notescreen/Eraser.png')),
                label: 'Eraser',
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                    onTap: () {
                      setState(() => drawingPoints = []);
                    },
                    child: Image.asset('assets/3notescreen/Clean.png')),
                label: 'All Clear',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 41, 28, 73),
            unselectedItemColor: Colors.black,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
                if (index == 0) {
                  isDrawingMode = true;
                  isErasing =
                      false; // Disable eraser mode when switching to Pen mode
                  openPenOptions(context);
                } else if (index == 2) {
                  // Eraser
                  toggleErasing(); // Toggle eraser mode
                  if (isErasing) {
                    selectedColor = selectedBackgroundColor.withOpacity(
                        0.6); // Set erase color to background color
                  }
                } else {
                  isDrawingMode = false;
                }
                if (index == 1) {
                  openColorPicker(context);
                }
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.black,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.undo,
                              size: 30,
                              color: Colors.black,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.redo,
                              size: 30,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                  child: Stack(
                children: [
                  Container(
                    width: 333,
                    height: 500,
                    decoration: BoxDecoration(color: selectedBackgroundColor),
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          drawingPoints.add(
                            DrawingPoint(
                              details.localPosition,
                              Paint()
                                ..color = selectedColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round,
                            ),
                          );
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          drawingPoints.add(
                            DrawingPoint(
                              details.localPosition,
                              Paint()
                                ..color = selectedColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round,
                            ),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          drawingPoints.add(null!);
                        });
                      },
                      child: SizedBox(
                        width: 333,
                        height: 500,
                        child: CustomPaint(
                          size: const Size(333, 500),
                          painter: _DrawingPainter(drawingPoints, eraserSize,
                              selectedBackgroundColor, isErasing),
                          child: const SizedBox(
                            width: 333,
                            height: 500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () => setState(() => selectedColor = color),
        child: Container(
          height: isSelected ? 47 : 40,
          width: isSelected ? 47 : 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border:
                isSelected ? Border.all(color: Colors.white, width: 3) : null,
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  final double eraserSize;
  final Color selectedBackgroundColor;
  final bool isErasing;
  _DrawingPainter(this.drawingPoints, this.eraserSize,
      this.selectedBackgroundColor, this.isErasing);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        if (!isErasing) {
          // Only draw when not in eraser mode.
          canvas.drawLine(
            drawingPoints[i].offset,
            drawingPoints[i + 1].offset,
            drawingPoints[i].paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

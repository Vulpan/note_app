import 'package:flutter/material.dart';

class ColorSlider extends StatefulWidget {
  const ColorSlider(
      {super.key,
      required this.color,
      required this.callback,
      required this.listOfColors,
      this.sliderNumber = 0});

  final Color color;
  final void Function(int, Color) callback;
  final List<Color> listOfColors;
  final int sliderNumber;

  @override
  State<ColorSlider> createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider> {
  final Icon _checkIcon = const Icon(Icons.check);
  int indexOfCurrentColor = 0;

  Color borderColor = const Color(0xffd3d3d3);
  Color foregroundColor = const Color(0xff595959);

  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.color;
    indexOfCurrentColor = widget.listOfColors.indexOf(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: List.generate(widget.listOfColors.length, (index) {
        return GestureDetector(
          onTap: () => colorIsTapped(index),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                foregroundColor: foregroundColor,
                backgroundColor: widget.listOfColors[index],
                child: indexOfCurrentColor == index ? _checkIcon : Container(),
              ),
            ),
          ),
        );
      }),
    );
  }

  void colorIsTapped(int indexOfColor) {
    setState(() {
      currentColor = widget.listOfColors[indexOfColor];
      indexOfCurrentColor = indexOfColor;
      widget.callback(widget.sliderNumber, widget.listOfColors[indexOfColor]);
    });
  }
}

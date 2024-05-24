import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  // 1
  final VoidCallback onTransform; // 6
  final String imgPath; // 2

  final bool isSelected;

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1; // 확대/축소 비율
  double hTransform = 0;
  double vTransform = 0;
  double actualScale = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Transform(
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform)
        ..scale(scale, scale),
        child : Container(
          decoration: widget.isSelected
              ? BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Colors.blue,
              width: 1.0,
            ),
          )
              : BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.transparent,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              // 3
              widget.onTransform(); // 6
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              // 4
              widget.onTransform(); // 6
              setState(() {
                scale = details.scale * actualScale;
                vTransform += details.focalPointDelta.dy;
                hTransform += details.focalPointDelta.dx;
              });
            },
            onScaleEnd: (ScaleEndDetails details) {
              actualScale = scale;
            },
            child: Image.asset(
              widget.imgPath, //
            ),
          ),
        )
    );


  }
}

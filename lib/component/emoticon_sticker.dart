import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  // 1
  final VoidCallback onTransform; // 6
  final String imgPath; // 2

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
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
    return GestureDetector(
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
    );
  }
}

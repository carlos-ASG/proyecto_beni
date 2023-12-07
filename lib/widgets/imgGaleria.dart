import 'package:flutter/material.dart';

class ImgGaleria extends StatelessWidget {
  final String imgPath;

  const ImgGaleria({required this.imgPath});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Image.network(
        imgPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

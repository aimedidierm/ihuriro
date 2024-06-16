import 'package:flutter/material.dart';

class AppBarClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(
      0,
      height * -0.0020000,
    );
    path.quadraticBezierTo(
      width * -0.0009375,
      height * 0.7510000,
      width * -0.0012500,
      height * 1.0020000,
    );
    path.cubicTo(
      width * -0.0013125,
      height * 0.8827800,
      width * 0.0668000,
      height * 0.8040600,
      width * 0.1250000,
      height * 0.8020000,
    );
    path.cubicTo(
      width * 0.3125000,
      height * 0.8015000,
      width * 0.6875000,
      height * 0.8005000,
      width * 0.8750000,
      height * 0.8000000,
    );
    path.cubicTo(
      width * 0.9345375,
      height * 0.8052000,
      width * 1.0003375,
      height * 0.8742400,
      width,
      height * 1.0020000,
    );
    path.quadraticBezierTo(
      width * 1.0003125,
      height * 0.7510000,
      width * 1.0012500,
      height * -0.0020000,
    );
    path.lineTo(
      0,
      height * -0.0020000,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

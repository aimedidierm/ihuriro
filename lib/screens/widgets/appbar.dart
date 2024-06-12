import 'package:flutter/material.dart';

class AppBarClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(
      width * -0.0050307,
      height * -0.0019437,
    );
    path.lineTo(
      width * -0.0050307,
      height * 0.6358735,
    );
    path.quadraticBezierTo(
      width * 0.0544036,
      height * 0.9635962,
      width * 0.1194983,
      height * 0.9660000,
    );
    path.cubicTo(
      width * 0.7440298,
      height * 0.8650390,
      width * 0.8283070,
      height * 0.9643974,
      width * 0.8754770,
      height * 0.9660000,
    );
    path.quadraticBezierTo(
      width * 0.9374271,
      height * 0.9643974,
      width * 1.0025217,
      height * 0.6390786,
    );
    path.lineTo(
      width * 1.0012639,
      height * -0.0051488,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class BorderTimeLine extends BorderDirectional {
  int position;

  BorderTimeLine(this.position);

  double radius = 5;
  double margin = 10;
  Paint _paint = Paint()
    ..color = Color(0xFFDDDDDD)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection textDirection,
        BoxShape shape = BoxShape.rectangle,
        BorderRadius borderRadius}) {
    if (position != 0) {
      canvas.drawLine(Offset(rect.left + margin + radius / 2, rect.top + 20),
          Offset(rect.left + margin + radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2),
          radius,
          _fillPaint());
      canvas.drawCircle(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2),
          radius,
          _strokePaint());
    } else {
      canvas.drawLine(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2 + 12),
          Offset(rect.left + margin + radius / 2, rect.bottom + 5),
          _strokePaint());
      canvas.drawCircle(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2),
          radius,
          _fillPaint());
      canvas.drawCircle(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2),
          radius,
          _strokePaint());
      canvas.drawCircle(
          Offset(rect.left + margin + radius / 2, rect.top + radius * 2),
          radius / 2,
          _strokePaint());
    }
  }

  Paint _fillPaint() {
    _paint.color = primary;
    _paint.style = PaintingStyle.fill;
    return _paint;
  }

  Paint _strokePaint() {
    _paint.color = primary;
    _paint.style = PaintingStyle.stroke;
    return _paint;
  }
}
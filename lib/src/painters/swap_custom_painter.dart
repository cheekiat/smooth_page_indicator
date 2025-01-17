import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/src/effects/swap_custom_effect.dart';
import 'package:smooth_page_indicator/src/effects/swap_effect.dart';

import 'indicator_painter.dart';

class SwapCustomPainter extends BasicIndicatorPainter {
  final SwapCustomEffect effect;
  List<Color>? colors;

  SwapCustomPainter({
    required double offset,
    required this.effect,
    required int count,
    this.colors
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    final current = offset.floor();
    final dotOffset = offset - offset.floor();
    // final activePaint = Paint()..color = effect.activeDotColor;

    var dotScale = effect.dotWidth * .2;
    final yPos = size.height / 2;
    final xAnchor = effect.spacing / 2;



    void drawDot(double xPos, double yPos, Paint paint, [double scale = 0]) {
      final rRect = RRect.fromLTRBR(
        xPos,
        yPos - effect.dotHeight / 2,
        xPos + effect.dotWidth,
        yPos + effect.dotHeight / 2,
        dotRadius,
      ).inflate(scale);

      canvas.drawRRect(rRect, paint);
    }

    for (var i = count - 1; i >= 0; i--) {
      // if current or next
      if (i == current || (i - 1 == current)) {
        if (effect.type == SwapType.yRotation) {
          final piFactor = (dotOffset * math.pi);
          if (i == current) {
            var x = (1 - ((math.cos(piFactor) + 1) / 2)) * distance;
            var y = -math.sin(piFactor) * distance / 2;

            final activePaint = Paint()
              ..shader = LinearGradient(
                colors: colors ?? <Color>[
                  Color(0xFFFFFF00), // yellow sun
                  Color(0xFF0099FF), // blue sky
                ],
              ).createShader(Rect.fromLTRB(     xAnchor + distance * i + x,
                yPos - effect.dotHeight / 2,
                xAnchor + distance * i + x + effect.dotWidth,
                yPos + effect.dotHeight / 2,));
            drawDot(xAnchor + distance * i + x, yPos + y, activePaint);
          } else {
            var x = -(1 - ((math.cos(piFactor) + 1) / 2)) * distance;
            var y = (math.sin(piFactor) * distance / 2);
            drawDot(xAnchor + distance * i + x, yPos + y, dotPaint);
          }
        } else {
          var posOffset = i.toDouble();
          var scale = 0.0;
          if (effect.type == SwapType.zRotation) {
            scale = dotScale * dotOffset;
            if (dotOffset > .5) {
              scale = dotScale - (dotScale * dotOffset);
            }
          }
          if (i == current) {
            posOffset = offset;

            final activePaint = Paint()
              ..shader = LinearGradient(
                colors: colors ?? <Color>[
                  Color(0xFFFFFF00), // yellow sun
                  Color(0xFF0099FF), // blue sky
                ],
              ).createShader(Rect.fromLTRB(     xAnchor + posOffset * distance,
                yPos - effect.dotHeight / 2,
                xAnchor + posOffset * distance + effect.dotWidth,
                yPos + effect.dotHeight / 2,));

            drawDot(xAnchor + posOffset * distance, yPos, activePaint, scale);
          } else {
            posOffset = i - dotOffset;
            drawDot(xAnchor + posOffset * distance, yPos, dotPaint, -scale);
          }
        }
      } else {
        // draw still dots
        final xPos = xAnchor + i * distance;
        drawDot(xPos, yPos, dotPaint);
      }
    }
  }
}

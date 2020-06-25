import 'dart:ui' as ui;
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  ui.Image image;
  final double fontSize;
  final double leftMargin;
  final double scale;
  final Size markerSize;
  ValueNotifier<String> time;
  CometThemeData _appTheme = locator<CometThemeManager>().theme;

  MarkerPainter({
    this.leftMargin = 2,
    this.fontSize = 10,
    this.scale = 2,
    @required this.markerSize,
    @required this.time,
    @required this.image,
  }) : super(repaint: time);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    final topMargin = size.height/5;
    size = markerSize;

    //draw outline for marker
    paint.color = _appTheme.mainColor;

    final double radius = 31.0*scale/2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius)
    );
    canvas.drawRRect(rRect, paint);

    //set bounds for image rect   
    final innerRect = Rect.fromLTWH(leftMargin*scale, topMargin, size.width-2*leftMargin*scale, size.height-leftMargin*scale-topMargin);
    final double innerRadius = radius-0.5;
    final RRect innerRRect = RRect.fromRectAndCorners(
      innerRect,
      topLeft: Radius.circular(innerRadius),
      topRight: Radius.circular(innerRadius),
      bottomLeft: Radius.circular(innerRadius)
    );

    //write time label and one day it'll work
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: this.time.value,
        style: TextStyle(
          fontSize: fontSize*scale,
          fontFamily: "Lexend Deca"
        )
      )
    );

    textPainter.layout( minWidth: 0, maxWidth: size.width-2*leftMargin );
    Offset textOffset = Offset( (size.width - textPainter.width)/2, (size.height-textPainter.height-innerRect.height)/2);
    textPainter.paint( canvas, textOffset);
  
    //clip canvas so that it is suitable for jafar's taste, if that's even possible
    canvas.clipRRect( innerRRect );
    canvas.drawRRect( innerRRect, paint );
    
    //apply BoxFit.cover but make it 17 times harder than it needs to be bc custom painter rox
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(BoxFit.cover, imageSize, innerRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(sizes.destination, innerRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }

  @override
  bool shouldRepaint(MarkerPainter old){
    if(markerSize!= old.markerSize)
      print('different');
    return time.value != old.time.value ||
    markerSize != old.markerSize;
  }
}
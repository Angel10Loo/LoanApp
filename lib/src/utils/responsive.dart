import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  late double _width, _height, _diagonal;
  late bool _isTable;
  late double _contentHeight;
  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get isTable => _isTable;
  double get contentHeight => _contentHeight;

  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    _isTable = size.shortestSide >= 600;

    var padding = MediaQuery.of(context).padding;
    _contentHeight = _height - padding.top - padding.bottom;
  }

  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;
}

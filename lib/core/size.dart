import 'package:flutter/widgets.dart';

class SizeConfig {
  static final SizeConfig _instance = SizeConfig._internal();

  factory SizeConfig() => _instance;

  SizeConfig._internal();

  late double _screenWidth;
  late double _screenHeight;
  late double _scaleFactor;

  void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _scaleFactor = _screenWidth / 375.0;
  }

  double get width => _screenWidth;
  double get height => _screenHeight;

  double wp(double percent) => _screenWidth * (percent / 100);
  double hp(double percent) => _screenHeight * (percent / 100);
  double sp(double fontSize) => fontSize * _scaleFactor;
}

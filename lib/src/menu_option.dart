import 'package:flutter/cupertino.dart';

class MenuOption {

  final BoxDecoration? decoration;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration? animationDuration;
  final double? maxHeight;

  MenuOption(
      {this.decoration,
        this.maxHeight,
      this.alignment,
      this.padding,
      this.margin,
      this.animationDuration});


}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


extension ContextConfig on BuildContext {

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;
  double get topPadding => MediaQuery.viewInsetsOf(this).top;
  bool get keyboardUp => MediaQuery.viewInsetsOf(this).bottom!=0;

  /// [MediaQuery].sizeOf(context).height
    double get height =>  MediaQuery.sizeOf(this).height;

  /// [MediaQuery].sizeOf(context).width
  double get width => MediaQuery.sizeOf(this).width;
  ColorScheme get colorScheme  => Theme.of(this).colorScheme;
}

import 'package:flutter/cupertino.dart';


extension ContextConfig on BuildContext {

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;
  bool get keyboardUp => MediaQuery.viewInsetsOf(this).bottom!=0;

  /// [MediaQuery].sizeOf(context).height
    double get height =>  MediaQuery.sizeOf(this).height;

  /// [MediaQuery].sizeOf(context).width
  double get width => MediaQuery.sizeOf(this).width;
}

import 'package:flutter/cupertino.dart';


extension ContextConfig on BuildContext {

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// [MediaQuery].sizeOf(context).height
    double get height =>  MediaQuery.sizeOf(this).height;

  /// [MediaQuery].sizeOf(context).width
  double get width => MediaQuery.sizeOf(this).width;
}

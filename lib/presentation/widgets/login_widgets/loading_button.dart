import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {super.key,
      required this.text,
       this.loading=false,
      required this.onPressed, this.width});

  final String text;
  final bool loading;
  final VoidCallback onPressed;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??context.width - 100,
      child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          child: loading ? const CupertinoActivityIndicator() : Text(text)),
    );
  }
}

import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {super.key,
      required this.text,
      required this.loading,
      required this.onPressed});

  final String text;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width - 100,
      child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          child: loading ? const CupertinoActivityIndicator() : Text(text)),
    );
  }
}

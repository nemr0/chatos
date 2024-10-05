import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: context.colorScheme.primaryContainer,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20,
          left: 20),
      content: SizedBox(
        width: context.width*.8,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Icon(CupertinoIcons.triangle_fill,
                color: context.colorScheme.primary),
            const SizedBox(width: 10,),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: context.colorScheme.primary),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

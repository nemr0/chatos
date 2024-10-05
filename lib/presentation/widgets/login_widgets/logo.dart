import 'package:chatos/generated/app_assets.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.side,  this.logoOnly=false});
  final double? side;
  final bool logoOnly;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
            borderRadius: logoOnly?null:BorderRadius.circular(20),
              color: logoOnly?null:context.colorScheme.onPrimaryContainer,
            ),
            child: Image.asset(AppAssets.ASSETS_WEBP_LOGO_WEBP,height:side?? 100,width: side??100,)),
         if(!logoOnly)Text('Chatos',style: TextStyle(fontSize: 16,color: context.colorScheme.primary),)
      ],
    );
  }
}

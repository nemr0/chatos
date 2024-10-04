import 'package:chatos/generated/app_assets.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: Image.asset(AppAssets.ASSETS_WEBP_LOGO_WEBP,height: 100,width: 100,)),
         Text('Chatos',style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary),)
      ],
    );
  }
}

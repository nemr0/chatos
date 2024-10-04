import 'package:chatos/generated/app_assets.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.ASSETS_WEBP_COSMIC_CLIFFS_WALLPAPER_WEBP,
        height: context.height,
        width: context.width,
      ),
      bottomSheet: Container(
        constraints: BoxConstraints(
          minHeight: context.height / 2,
          maxHeight: context.height,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

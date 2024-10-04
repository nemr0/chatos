import 'package:chatos/business/auth_cubit.dart';
import 'package:chatos/generated/app_assets.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/helpers/validators/email_validator.dart';
import 'package:chatos/presentation/helpers/validators/password_validator.dart';
import 'package:chatos/presentation/screens/home/home_screen.dart';
import 'package:chatos/presentation/widgets/login_widgets/custom_text_field.dart';
import 'package:chatos/presentation/widgets/login_widgets/loading_button.dart';
import 'package:chatos/presentation/widgets/login_widgets/logo.dart';
import 'package:chatos/presentation/widgets/show_error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();

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

  onLogin() {
    if (formKey.currentState!.validate()) {
      AuthCubit.get(context)
          .loginOrRegister(emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if(state is AuthErrorState){
          showErrorSnackBar(context,state.message);
        }
        if(state is AuthSuccessState){
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route,(r)=>false);
        }
      },
      child: Scaffold(

        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Image.asset(
              AppAssets.ASSETS_WEBP_COSMIC_CLIFFS_WALLPAPER_WEBP,
              height: context.height * .6,
              width: context.width,
              fit: BoxFit.cover,
            ),
          ],
        ),
        bottomSheet: AnimatedContainer(
          constraints: BoxConstraints(maxHeight: context.height * .8),
          height: (context.height * .6) + context.keyboardHeight,
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          duration: const Duration(milliseconds: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const Spacer(),
                CustomTextField(
                  validator: emailValidator,
                  hintText: 'Email Address',
                  controller: emailController,
                ),
                const Spacer(),
                CustomTextField(
                  validator: passwordValidator,
                  hintText: 'Password',
                  controller: passwordController,
                  action: TextInputAction.done,
                  onSubmitted: onLogin,
                ),
                const Spacer(
                  flex: 4,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return LoadingButton(
                      text: 'Login',
                      loading: state is AuthLoadingsState,
                      onPressed: onLogin,
                    );
                  },
                ),
                const Spacer(
                  flex: 4,
                ),
                SizedBox(
                  height: context.keyboardHeight,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, this.action, required this.controller, this.onSubmitted, required this.hintText, required this.validator});
  final TextInputAction? action;
  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  final String hintText;
  final String? Function(String?) validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: action??TextInputAction.next,
      onFieldSubmitted:(s){
        onSubmitted?.call();
      } ,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      decoration: InputDecoration(
        hintText: hintText,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: BorderSide(color: Theme.of(context).colorScheme.primary))
      ),
    );
  }
}

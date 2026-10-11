import 'package:flutter/material.dart';

class Custemtextformfield extends StatelessWidget {
  Custemtextformfield(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      required this.maxLines,
      this.onchanged,
      this.onTap,
      required this.readOnly,
      required this.filled,
      required this.fillColor,
      this.contentPadding,
      this.hintStyle,
      required this.label,
      
      
      });

  //we takes variables for textformfield
  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onchanged;
  final void Function()? onTap;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final Widget? label;
  final Widget? suffixIcon;
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onchanged,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,     
      decoration: InputDecoration(
          contentPadding: contentPadding,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: filled,
          hintText: hintText,
          hintStyle: hintStyle,
          fillColor: fillColor, 
          label: label, 
          

          ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}

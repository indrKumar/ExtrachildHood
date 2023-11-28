import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFormTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? prefix;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Color? cursorColor;
  final Color? fillColor;
  final bool? filled;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? prefixTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool? obscureText;
  final bool? readOnly;
  final ValueChanged<String>? onChanged;

  const MyFormTextField({
    Key? key,
    this.controller,
    this.hintStyle,
    this.prefixIcon,
    this.prefix,
    this.hintText,
    this.suffixIcon,
    this.cursorColor,
    this.fillColor,
    this.filled,
    this.textAlign,
    this.textInputType,
    this.onTap,
    this.inputFormatters,
    this.prefixTextStyle,
    this.style,
    this.obscureText,
    this.readOnly,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly == false,
      style: style,
      textAlign: textAlign ?? TextAlign.center,
      obscureText: obscureText ?? false,
      keyboardType: textInputType,
      cursorColor: cursorColor,
      controller: controller,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20,top: 15,bottom: 15),
        prefixStyle: prefixTextStyle,
        prefixText: prefix,
        hintText: hintText,
        prefixIcon: prefixIcon,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        fillColor: fillColor,
        filled: filled,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onChanged:onChanged,
      onTap: onTap,
    );
  }
}

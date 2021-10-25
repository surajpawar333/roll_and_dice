import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.labelText,
    this.editingController,
    this.initialText,
    this.isPassword = false,
    this.hintText = "",
    this.errorText,
    this.onChange,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  final bool isPassword;
  final String hintText;
  final TextEditingController? editingController;
  final String? errorText;
  final String? initialText;
  final String labelText;
  final Function? onChange;
  final IconData? prefixIcon;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: editingController,
      initialValue: initialText,
      obscureText: isPassword,
      onChanged: (value) {
        if (onChange != null) onChange!(value);
      },
      decoration: InputDecoration(
        focusColor: Colors.grey,
        labelText: labelText,
        errorText: errorText,
        hintText: hintText,
        errorMaxLines: 2,
        labelStyle: TextStyle(color: Theme.of(context).focusColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).focusColor, width: 1.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 22, color: Colors.grey) : null,
        suffixIcon: errorText != null
            ? Icon(
                Icons.error,
                color: Colors.red,
              )
            : SizedBox(),
      ),
    );
  }
}

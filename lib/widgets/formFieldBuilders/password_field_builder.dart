import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'form_input_builder.dart';

class PasswordBuilder extends StatefulWidget {
  final String? labelText;
  final String name;
  final EdgeInsets? margin;
  final String? initialValue;
  final Function(String?)? onChange;
  final FormFieldValidator<String?>? validator;

  const PasswordBuilder({
    Key? key,
    this.labelText,
    this.name = 'password',
    this.margin,
    this.initialValue,
    this.validator,
    this.onChange,
  }) : super(key: key);

  @override
  _PasswordBuilderState createState() => _PasswordBuilderState();
}

class _PasswordBuilderState extends State<PasswordBuilder> {
  bool isPasswordVisible = true;

  toggle() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormInputBuilder(
      obscureText: isPasswordVisible,
      margin: widget.margin,
      attribute: widget.name,
      labelText: widget.labelText!.tr,
      onChanged: widget.onChange,
      validator: widget.validator,
      maxLength: 25,

      ///change this maxLines from null to maxLines = 1
      maxLines: 1,
      textCapitalization: TextCapitalization.none,
      initialValue: widget.initialValue,
    );
  }
}

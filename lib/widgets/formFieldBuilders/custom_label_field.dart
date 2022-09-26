import 'package:fitnessapp/config/text_styles.dart';
import 'package:flutter/cupertino.dart';

class CustomLabelField extends StatelessWidget {
  final String labelText;

  const CustomLabelField({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText.toUpperCase(),
      style: TextStyles.textFieldLabelStyleSmallGray,
    );
  }
}

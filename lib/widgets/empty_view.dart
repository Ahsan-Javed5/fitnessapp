import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyView extends StatelessWidget {
  final String? customMessage;
  final Color? textColor;
  final bool showFullMessage;

  const EmptyView({
    Key? key,
    this.customMessage,
    this.textColor,
    this.showFullMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        customMessage ?? (showFullMessage
                ? 'empty_full_message'.tr
                : 'empty_half_message'.tr),
        textAlign: TextAlign.center,
      ),
    );
  }
}

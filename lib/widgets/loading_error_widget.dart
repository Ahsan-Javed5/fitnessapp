import 'package:fitnessapp/config/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class LoadingErrorWidget extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final bool isError;
  final Widget child;
  final VoidCallback? refreshCallback;

  const LoadingErrorWidget({
    Key? key,
    this.isLoading = false,
    this.errorMessage = '',
    required this.child,
    this.isError = false,
    this.refreshCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mErrorMessage = '';

    if (errorMessage.isEmpty) {
      mErrorMessage = 'something_went_wrong'.tr;
    } else if (errorMessage.toLowerCase().contains('socketexception')) {
      mErrorMessage = 'check_internet_try_again'.tr;
    } else {
      mErrorMessage = errorMessage;
    }
    return (!isLoading && !isError)
        ? child
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    isLoading ? 'loading'.tr : mErrorMessage,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (!isLoading)
                TextButton.icon(
                  onPressed: refreshCallback,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'retry'.tr,
                    style: TextStyles.normalBlueBodyText,
                  ),
                )
            ],
          );
  }
}

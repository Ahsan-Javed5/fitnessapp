import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final Color backgroundColor;
  final double clipRadius;
  final bool showDummyImageInstead;
  final String? placeholderUrl;
  final bool useCacheImageLib;
  final bool useDefaultBaseUrl;

  const CustomNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.fit = BoxFit.cover,
      this.backgroundColor = ColorConstants.whiteColor,
      this.clipRadius = 0,
      this.showDummyImageInstead = false,
      this.placeholderUrl,
      this.useCacheImageLib = true,
      this.useDefaultBaseUrl = true})
      : super(key: key);

  /// Added new image library to cache images
  /// If we need to use the old library then we have to set the [useCacheImageLib] to false
  @override
  Widget build(BuildContext context) {
    String? finalUrl = (imageUrl?.contains(MyHive.sasKey) ?? false)
        ? imageUrl
        : '${useDefaultBaseUrl ? '' : ''}$imageUrl${MyHive.sasKey}';
    return ClipRRect(
      borderRadius: BorderRadius.circular(clipRadius),
      child: useCacheImageLib
          ? CachedNetworkImage(
              imageUrl: finalUrl!,
              fit: fit,
              placeholder: (context, url) => Image.asset(
                placeholderUrl ?? 'assets/images/splash_bg_with_logo.png',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Image.asset(
                placeholderUrl ?? 'assets/images/splash_bg_with_logo.png',
                fit: BoxFit.cover,
              ),
            )
          : Image.network(
              showDummyImageInstead
                  ? 'https://picsum.photos/id/227/600/900'
                  : '${useDefaultBaseUrl ? '' : ''}$imageUrl${MyHive.sasKey}',
              fit: fit,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                placeholderUrl ?? 'assets/images/splash_bg_with_logo.png',
                fit: BoxFit.cover,
              ),
              loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress == null
                    ? child
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: (loadingProgress.cumulativeBytesLoaded *
                                    100) /
                                (loadingProgress.expectedTotalBytes ?? 500000),
                          ),
                        ),
                      );
              },
            ),
    );
  }
}

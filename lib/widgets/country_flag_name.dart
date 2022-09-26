import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:flutter/cupertino.dart';

class CountryFlagAndName extends StatelessWidget {
  final String countryInitials;
  final double? width;
  final double? height;

  const CountryFlagAndName({
    Key? key,
    required this.countryInitials,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Country country =
    countryInitials.length < 3 ?
        CountryPickerUtils.getCountryByIsoCode(countryInitials.toLowerCase()) :
        CountryPickerUtils.getCountryByIso3Code(countryInitials.toLowerCase());
    return Row(
      children: [
        SizedBox(
          height: Spaces.normY(2),
          width: Spaces.normY(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: CountryPickerUtils.getDefaultFlagImage(country),
          ),
        ),
        SizedBox(
          width: Spaces.normX(1.5),
        ),
        Text(
          country.name,
          style: TextStyles.normalBlackBodyText.copyWith(
            fontSize: Spaces.normSP(10),
          ),
        ),
      ],
    );
  }
}

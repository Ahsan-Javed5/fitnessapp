import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';

class MultiSelectDialog extends StatelessWidget {
  /// List to display items
  final List<String> items;

  /// List to hold the multiple sub headings
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool>? mappedItem;

  MultiSelectDialog({Key? key, required this.items}) : super(key: key);

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(
      items,
      key: (k) => k.toString(),
      value: (v) {
        if (v != true && v != false) {
          return false;
        } else {
          return v as bool;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      children: [
        ...mappedItem!.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => SizedBox(
              height: Spaces.normY(4),
              child: CheckboxListTile(
                title: Text(
                  key,
                  style: TextStyles.subHeadingWhiteMedium
                      .copyWith(color: ColorConstants.appBlack),
                ),
                value: mappedItem![key],
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Spaces.normX(4), vertical: 0),
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (value) => setState(() => mappedItem![key] = value!),
              ),
            ),
          );
        }).toList(),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: const ButtonStyle(visualDensity: VisualDensity.comfortable),
            child: const Text('Submit'),
            onPressed: () {
              // Clear the list
              selectedItems.clear();

              // Traverse each map entry
              mappedItem!.forEach(
                (key, value) {
                  if (value == true) {
                    selectedItems.add(key);
                  }
                },
              );

              // Close the Dialog & return selectedItems
              Navigator.pop(context, selectedItems);
            },
          ),
        ),
      ],
    );
  }
}

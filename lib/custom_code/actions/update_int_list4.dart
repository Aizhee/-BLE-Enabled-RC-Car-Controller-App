// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<int>> updateIntList4(
  List<int> inputList,
  int? field1,
  int? field2,
  int? field3,
  int? field4,
) async {
  // Make a copy of the list so we can modify it
  List<int> newList = List.from(inputList);

  // Group all the new field values into a list
  final fields = [field1, field2, field3, field4];

  for (int i = 0; i < fields.length; i++) {
    final fieldValue = fields[i];

    // Check if a value was provided for this field
    // (fieldValue != null) also handles 0, which is valid
    if (fieldValue != null) {
      // Check if the list is long enough to have this index.
      if (i < newList.length) {
        // Update the value at the specific index.
        newList[i] = fieldValue;
      }
    }
  }

  // Return the modified list
  return newList;
}
// DO NOT REMOVE OR MODIFY THE CODE BELOW!
// ...
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

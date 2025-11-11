// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> updateStringList8(
  List<String> inputList,
  String? field1,
  String? field2,
  String? field3,
  String? field4,
  String? field5,
  String? field6,
  String? field7,
  String? field8,
) async {
  // Make a copy of the list so we can modify it
  List<String> newList = List.from(inputList);

  // Group all the new field values into a list
  final fields = [
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8
  ];

  for (int i = 0; i < fields.length; i++) {
    final fieldValue = fields[i];

    // Check if a value was provided for this field
    if (fieldValue != null) {
      // Check if the list is long enough to have this index.
      // This is the "don't add" logic.
      if (i < newList.length) {
        // This is the "update at index" logic.
        newList[i] = fieldValue;
      }
    }
  }

  // Return the modified list
  return newList;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

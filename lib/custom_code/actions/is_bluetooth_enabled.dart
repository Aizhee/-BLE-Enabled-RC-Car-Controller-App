// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bt;

Future<bool> isBluetoothEnabled() async {
  bool bleEnabled = false;
  bool btEnabled = false;

  // -----------------------------
  // Check BLE
  // -----------------------------
  if (await ble.FlutterBluePlus.isSupported) {
    ble.BluetoothAdapterState state =
        await ble.FlutterBluePlus.adapterState.first;
    if (state == ble.BluetoothAdapterState.on) {
      bleEnabled = true;
    }
  } else {
    debugPrint("BLE not supported by this device");
  }

  // -----------------------------
  // Check BT2.0
  // -----------------------------
  try {
    btEnabled = await bt.FlutterBluetoothSerial.instance.isEnabled ?? false;
  } catch (e) {
    debugPrint("BT2.0 check failed: $e");
  }

  // Return true if either BLE or BT2.0 is enabled
  return bleEnabled || btEnabled;
}

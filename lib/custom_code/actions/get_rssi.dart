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

// Optional global map for BT2.0 connections (if not already defined)
final Map<String, bt.BluetoothConnection> btConnections = {};

Future<int> getRssi(BTDeviceStruct deviceInfo) async {
  int retrievedRssi = -1;

  try {
    if (deviceInfo.type == 'BLE') {
      final device = ble.BluetoothDevice.fromId(deviceInfo.id);
      retrievedRssi = await device.readRssi();
    } else if (deviceInfo.type == 'BT2.0') {
      // BT2.0 RSSI not directly available, return placeholder or last known RSSI
      retrievedRssi = deviceInfo.rssi;
    } else {
      debugPrint("Unknown device type: ${deviceInfo.type}");
      retrievedRssi = -1;
    }
  } catch (e) {
    debugPrint("Error reading RSSI: $e");
    retrievedRssi = -1;
  }

  return retrievedRssi;
}

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

// Global map to store active BT2.0 connections
final Map<String, bt.BluetoothConnection> btConnections = {};

Future<void> disconnectDevice(BTDeviceStruct deviceInfo) async {
  try {
    if (deviceInfo.type == 'BLE') {
      // -----------------------------
      // BLE DISCONNECT
      // -----------------------------
      final device = ble.BluetoothDevice.fromId(deviceInfo.id);
      await device.disconnect();
      debugPrint('Disconnected BLE device: ${deviceInfo.name}');
    } else if (deviceInfo.type == 'BT2.0') {
      // -----------------------------
      // BT2.0 DISCONNECT using map
      // -----------------------------
      final connection = btConnections[deviceInfo.id];

      if (connection != null) {
        await connection
            .close(); // recommended instead of deprecated disconnect
        btConnections.remove(deviceInfo.id); // remove from map
        debugPrint('Disconnected BT2.0 device: ${deviceInfo.name}');
      } else {
        debugPrint('No BT2.0 connection found for: ${deviceInfo.name}');
      }
    } else {
      debugPrint("Unknown device type: ${deviceInfo.type}");
    }
  } catch (e) {
    debugPrint('Error disconnecting device: $e');
  }
}

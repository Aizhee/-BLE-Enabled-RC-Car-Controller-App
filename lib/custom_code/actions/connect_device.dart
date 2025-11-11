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

Future<bool> connectDevice(BTDeviceStruct deviceInfo) async {
  bool hasWriteCharacteristic = false;

  try {
    if (deviceInfo.type == 'BLE') {
      // -----------------------------
      // BLE connection
      // -----------------------------
      final device = ble.BluetoothDevice.fromId(deviceInfo.id);

      await device.connect(
        license: ble.License.free,
        timeout: const Duration(seconds: 35),
        mtu: 512,
        autoConnect: false,
      );

      final services = await device.discoverServices();

      for (ble.BluetoothService service in services) {
        for (ble.BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write) {
            debugPrint(
              'Found write characteristic: ${characteristic.uuid}, ${characteristic.properties}',
            );
            hasWriteCharacteristic = true;
          }
        }
      }
    } else if (deviceInfo.type == 'BT2.0') {
      // -----------------------------
      // Classic BT connection
      // -----------------------------
      bt.BluetoothConnection connection =
          await bt.BluetoothConnection.toAddress(deviceInfo.id);

      // store in global map instead of deviceInfo
      btConnections[deviceInfo.id] = connection;

      debugPrint('Connected to BT2.0 device: ${deviceInfo.name}');
      hasWriteCharacteristic = true; // Classic BT supports write via serial
    } else {
      debugPrint("Unknown device type: ${deviceInfo.type}");
    }
  } catch (e) {
    debugPrint('Connection failed: $e');
  }

  return hasWriteCharacteristic;
}

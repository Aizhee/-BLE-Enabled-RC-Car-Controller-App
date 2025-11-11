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

// Global map for BT2.0 connections
final Map<String, bt.BluetoothConnection> btConnections = {};

Future sendData(BTDeviceStruct deviceInfo, String data) async {
  try {
    if (deviceInfo.type == 'BLE') {
      final device = ble.BluetoothDevice.fromId(deviceInfo.id);
      final services = await device.discoverServices();
      for (final service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.properties.write &&
              characteristic.properties.notify) {
            await characteristic.write(data.codeUnits);
          }
        }
      }
    } else if (deviceInfo.type == 'BT2.0') {
      final connection = btConnections[deviceInfo.id];
      if (connection != null) {
        connection.output.add(Uint8List.fromList(data.codeUnits));
        await connection.output.allSent;
      } else {
        debugPrint('BT2.0 device not connected: ${deviceInfo.name}');
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

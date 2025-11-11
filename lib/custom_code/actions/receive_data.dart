// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bt;

// Global map for BT2.0 connections
final Map<String, bt.BluetoothConnection> btConnections = {};

Future<String?> receiveData(BTDeviceStruct deviceInfo) async {
  try {
    if (deviceInfo.type == 'BLE') {
      final device = ble.BluetoothDevice.fromId(deviceInfo.id);
      final services = await device.discoverServices();

      for (final service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.properties.read &&
              characteristic.properties.notify) {
            final value = await characteristic.read();
            return String.fromCharCodes(value);
          }
        }
      }
      // No matching characteristic found
      return null;
    } else if (deviceInfo.type == 'BT2.0') {
      final connection = btConnections[deviceInfo.id];
      if (connection != null) {
        final completer = Completer<String?>();
        final sub = connection.input?.listen((Uint8List data) {
          if (!completer.isCompleted) {
            completer.complete(String.fromCharCodes(data));
          }
        });

        final result = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            if (!completer.isCompleted) completer.complete(null);
            return null; // Explicitly returns String? for timeout
          },
        );

        // Cancel subscription after first data or timeout
        await sub?.cancel();
        return result;
      } else {
        debugPrint('BT2.0 device not connected: ${deviceInfo.name}');
        return null;
      }
    } else {
      debugPrint('Unknown device type: ${deviceInfo.type}');
      return null;
    }
  } catch (e) {
    debugPrint('Receive data error: $e');
    return null;
  }
}

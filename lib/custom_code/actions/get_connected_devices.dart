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

Future<List<BTDeviceStruct>> getConnectedDevices() async {
  final List<BTDeviceStruct> deviceList = [];

  // ----------------------------------------
  // 1. GET BLE CONNECTED DEVICES
  // ----------------------------------------
  final Set<String> bleDeviceIds = {};
  final List<ble.BluetoothDevice> bleConnected =
      ble.FlutterBluePlus.connectedDevices;

  for (final dev in bleConnected) {
    final id = dev.remoteId.toString();
    final name = dev.platformName.isEmpty ? 'Unknown' : dev.platformName;

    deviceList.add(
      BTDeviceStruct(
        id: id,
        // ---- MODIFIED LINE ----
        name: '$name (BLE)', // Appending label to the name
        type: 'BLE',
      ),
    );
    bleDeviceIds.add(id);
  }

  // ----------------------------------------
  // 2. GET BT2.0 CONNECTED DEVICES
  // ----------------------------------------
  try {
    final List<bt.BluetoothDevice> classicBonded =
        await bt.FlutterBluetoothSerial.instance.getBondedDevices();
    final Map<String, String> bondedDeviceNames = {
      for (var d in classicBonded) d.address: d.name ?? 'Unknown'
    };

    // Iterate over the connections you are actively managing
    for (final String deviceId in btConnections.keys) {
      final bt.BluetoothConnection? connection = btConnections[deviceId];

      if (connection != null && connection.isConnected) {
        // Prioritization: Skip if we already have this device as BLE
        if (bleDeviceIds.contains(deviceId)) {
          continue;
        }

        final name = bondedDeviceNames[deviceId] ?? 'Unknown';
        deviceList.add(
          BTDeviceStruct(
            id: deviceId,
            // ---- MODIFIED LINE ----
            name: '$name (BT2.0)', // Appending label to the name
            type: 'BT2.0',
          ),
        );
      }
    }
  } catch (e) {
    debugPrint("BT2.0 read error: $e");
  }

  return deviceList;
}

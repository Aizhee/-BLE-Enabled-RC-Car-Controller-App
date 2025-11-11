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
  // BLE CONNECTED DEVICES
  // ----------------------------------------
  final List<ble.BluetoothDevice> bleConnected =
      ble.FlutterBluePlus.connectedDevices;

  for (final dev in bleConnected) {
    final id = dev.remoteId.toString();
    final name = dev.platformName.isEmpty ? 'Unknown' : dev.platformName;

    deviceList.add(
      BTDeviceStruct(
        id: id,
        name: name,
        type: 'BLE',
      ),
    );
  }

  // ----------------------------------------
  // BT2.0 BONDED DEVICES
  // ----------------------------------------
  try {
    List<bt.BluetoothDevice> classicBonded =
        await bt.FlutterBluetoothSerial.instance.getBondedDevices();

    for (final d in classicBonded) {
      deviceList.add(
        BTDeviceStruct(
          id: d.address,
          name: d.name ?? 'Unknown',
          type: 'BT2.0',
        ),
      );
    }
  } catch (e) {
    debugPrint("BT2.0 read error: $e");
  }

  return deviceList;
}

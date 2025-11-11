// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Future<List<BTDeviceStruct>> findDevices() async {
  List<BTDeviceStruct> devices = [];

  try {
    // -----------------------------
    // BLE SCAN (FlutterBluePlus)
    // -----------------------------
    var bleSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        if (r.device.platformName.isNotEmpty) {
          devices.add(
            BTDeviceStruct(
              name: r.device.platformName,
              id: r.device.remoteId.toString(),
              rssi: r.rssi,
            ),
          );
        }
      }
    });

    await FlutterBluePlus.adapterState
        .where((s) => s == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 3),
      androidUsesFineLocation: true,
    );

    await FlutterBluePlus.isScanning.where((v) => v == false).first;
    //FlutterBluePlus.cancelWhenScanComplete(bleSubscription);

    // -----------------------------
    // BT 2.0 SCAN (flutter_bluetooth_serial)
    // -----------------------------
    List<BluetoothDiscoveryResult> classicScan =
        await FlutterBluetoothSerial.instance.startDiscovery().toList();

    for (var r in classicScan) {
      devices.add(
        BTDeviceStruct(
          name: r.device.name ?? "Unknown",
          id: r.device.address,
          rssi: r.rssi ?? 0,
        ),
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return devices;
}

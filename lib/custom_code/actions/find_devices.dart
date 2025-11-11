// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async'; // Added for StreamSubscription
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bt;

Future<List<BTDeviceStruct>> findDevices() async {
  // Use a Map to automatically handle all de-duplication
  final Map<String, BTDeviceStruct> deviceMap = {};
  StreamSubscription? bleSubscription;

  try {
    // -----------------------------
    // 1. REQUEST PERMISSIONS (CRITICAL)
    // -----------------------------
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // Required for BLE scanning
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
        statuses[Permission.locationWhenInUse] != PermissionStatus.granted) {
      debugPrint("Permissions not granted. Cannot scan.");
      return []; // Return empty list if permissions denied
    }

    // -----------------------------
    // 2. BLE SCAN (FlutterBluePlus)
    // -----------------------------

    // Wait for adapter to be on
    await ble.FlutterBluePlus.adapterState
        .where((s) => s == ble.BluetoothAdapterState.on)
        .first;

    bleSubscription = ble.FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        if (r.device.platformName.isNotEmpty) {
          final id = r.device.remoteId.toString();
          final name = r.device.platformName;

          // Add to map. Duplicates are automatically handled.
          deviceMap[id] = BTDeviceStruct(
            name: '$name (BLE)', // Added label
            id: id,
            rssi: r.rssi,
            type: 'BLE', // Added type
          );
        }
      }
    });

    await ble.FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4), // A 4-second scan is reasonable
      androidUsesFineLocation: true,
    );

    // Wait for scan to stop
    await ble.FlutterBluePlus.isScanning.where((v) => v == false).first;
    bleSubscription.cancel(); // Stop listening

    // -----------------------------
    // 3. BT 2.0 SCAN (flutter_bluetooth_serial)
    // -----------------------------

    // Check if Bluetooth Classic is enabled
    bool? isEnabled = await bt.FlutterBluetoothSerial.instance.isEnabled;
    if (isEnabled == true) {
      List<bt.BluetoothDiscoveryResult> classicScan =
          await bt.FlutterBluetoothSerial.instance.startDiscovery().toList();

      for (var r in classicScan) {
        if (r.device.name != null && r.device.name!.isNotEmpty) {
          final id = r.device.address;

          // ---- PRIORITIZATION LOGIC ----
          // Only add if it's NOT already in the map from the BLE scan
          if (!deviceMap.containsKey(id)) {
            final name = r.device.name ?? "Unknown";

            deviceMap[id] = BTDeviceStruct(
              name: '$name (BT2.0)', // Added label
              id: id,
              rssi: r.rssi ?? -100, // Use a default low RSSI
              type: 'BT2.0', // Added type
            );
          }
        }
      }
    } else {
      debugPrint("Bluetooth Classic is not enabled. Skipping BT2.0 scan.");
    }
  } catch (e) {
    debugPrint("findDevices error: ${e.toString()}");
  } finally {
    // Ensure subscription is always cancelled
    bleSubscription?.cancel();
    // Ensure scanning is always stopped
    if (ble.FlutterBluePlus.isScanningNow) {
      await ble.FlutterBluePlus.stopScan();
    }
  }

  // Convert the map's values back into a list
  return deviceMap.values.toList();
}

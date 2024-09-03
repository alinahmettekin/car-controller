import 'dart:developer' as DEV;

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothHelper {
  static FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  static List<BluetoothDevice> devices = [];
  static BluetoothConnection? connection;

  static Future<BluetoothConnection?> connectToDevice(String address) async {
    BluetoothConnection connection;
    try {
      connection = await BluetoothConnection.toAddress(address);

      DEV.log('Connected to the device');
      return connection;
    } catch (exception) {
      DEV.log("Cannot connect, exception occurred: $exception");
    }
    return null;
  }

  static Future<List<BluetoothDevice>> scanDevices() async {
    devices.clear();
    try {
      bluetooth.startDiscovery().listen((r) {
        final existingIndex = devices.indexWhere((element) => element.address == r.device.address);
        if (existingIndex >= 0) {
          devices[existingIndex] = r.device;
        } else {
          devices.add(r.device);
        }
      });
      return devices;
    } catch (ex) {
      DEV.log('Error scanning Bluetooth devices: $ex');
    }
    return [];
  }

  static Future<void> checkBluetoothStatus() async {
    bool isEnabled = await bluetooth.isEnabled ?? false;
    if (!isEnabled) {
      await bluetooth.requestEnable();
    }
  }

  static void sendData(String data) async {
    data = data.trim();
    if (data.isNotEmpty && (connection != null)) {
      try {
        List<int> list = data.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        connection!.output.add(bytes);
        await connection!.output.allSent;
        DEV.log('Veri gönderildi: $data');
      } catch (e) {
        DEV.log('Veri gönderme hatası: $e');
      }
    }
  }
}

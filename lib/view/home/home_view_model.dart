import 'package:carcontrol_mobx/core/helper/bluetooth_helper.dart';
import 'package:carcontrol_mobx/core/helper/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:developer' as dev;

class HomeViewModel extends ChangeNotifier {
  late BluetoothConnection? connection;
  late bool isScanning = false;
  late AnimationController animationController;
  List<BluetoothDevice> devices = [];

  Future<void> checkBluetoothStatus() async {
    await BluetoothHelper.checkBluetoothStatus();
  }

  void scanDevices() async {
    isScanning = true;
    try {
      devices = await BluetoothHelper.scanDevices();
      isScanning = false;
    } catch (e) {
      dev.log('Error scanning Bluetooth devices: $e');
      isScanning = false;
    }
    notifyListeners();
  }

  void connectToDevice(BluetoothDevice device, BuildContext context) async {
    DialogHelper.connectDialog(context, "Lütfen Bekleyin", device.name);

    try {
      connection = await BluetoothHelper.connectToDevice(device.address);
      if (connection == null) {
      } else {}
    } catch (exception) {
      dev.log('Cannot connect, exception occurred: $exception');
    }
    notifyListeners();
  }
}

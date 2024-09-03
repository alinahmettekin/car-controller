import 'dart:developer' as dev;

import 'package:carcontrol_mobx/core/helper/bluetooth_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlViewModel extends ChangeNotifier {
  String direction = "Dur";
  Map<String, String> buttonOptions = {
    'Sol': '',
    'Sağ': '',
    'İleri': '',
    'Geri': '',
    'Dur': '',
    'Buton 1': '',
    'Buton 2': '',
    'Buton 3': '',
    'Buton 4': '',
  };

  void sendData(String data) {
    if (data.isNotEmpty) {
      try {
        BluetoothHelper.sendData(data);
        dev.log('Veri gönderildi: $data');
      } catch (e) {
        dev.log('Veri gönderme hatası: $e');
        // Hata durumunda kullanıcıya bilgi verebilirsiniz
      }
    }
  }

  void loadButtonOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    buttonOptions.forEach((key, value) {
      buttonOptions[key] = prefs.getString(key) ?? '';
    });
  }

  void sendCommand(String command) {
    if (command.isNotEmpty) {
      dev.log('Gönderilen komut: $command');
      dev.log(buttonOptions.toString());
      sendData(command);
    }
  }
}

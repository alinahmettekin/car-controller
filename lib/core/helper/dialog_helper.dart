import 'package:flutter/material.dart';

class DialogHelper {
  static connectDialog(BuildContext context, String title, String? deviceName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text('${deviceName ?? 'Unknown'} bağlanılıyor...'),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class MediaHelper {
  static double getHeight(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  static double getWidth(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }
}

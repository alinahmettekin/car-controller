import 'package:flutter/material.dart';

class RouteHelper {
  static Future pushReplacement(BuildContext context, dynamic view) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => view,
        ));
  }

  static Future push(BuildContext context, dynamic view) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => view,
      ),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}

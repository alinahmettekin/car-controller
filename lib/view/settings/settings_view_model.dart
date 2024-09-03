import 'package:carcontrol_mobx/core/helper/route_helper.dart';
import 'package:carcontrol_mobx/view/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  late Map<String, String> buttonOptions;
  late Map<String, TextEditingController> controllers;

  Future<Map<String, String>> showOptionsScreen(BuildContext context, Map<String, String> currentOptions) async {
    return await RouteHelper.push(context, SettingsView(currentOptions: currentOptions));
  }

  saveButtonOption(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

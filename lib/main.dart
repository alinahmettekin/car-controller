import 'package:carcontrol_mobx/core/theme/app_theme.dart';
import 'package:carcontrol_mobx/view/control/control_view_model.dart';
import 'package:carcontrol_mobx/view/home/home_view.dart';
import 'package:carcontrol_mobx/view/home/home_view_model.dart';
import 'package:carcontrol_mobx/view/settings/settings_view.dart';
import 'package:carcontrol_mobx/view/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CarControllerApp());
}

class CarControllerApp extends StatelessWidget {
  const CarControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ControlViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        )
      ],
      child: const HomeView(),
    );
  }
}

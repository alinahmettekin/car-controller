import 'package:carcontrol_mobx/view/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  final Map<String, String> currentOptions;
  const SettingsView({super.key, required this.currentOptions});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    final svm = context.read<SettingsViewModel>();
    svm.buttonOptions = Map.from(widget.currentOptions);
    svm.controllers = {};
    svm.buttonOptions.forEach((key, value) {
      svm.controllers[key] = TextEditingController(text: value);
    });
    _loadButtonOptions();
  }

  @override
  void dispose() {
    final svm = context.read<SettingsViewModel>();
    for (var controller in svm.controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  _loadButtonOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    final svm = context.read<SettingsViewModel>();
    svm.buttonOptions.forEach((key, value) {
      String savedValue = prefs.getString(key) ?? value;
      svm.buttonOptions[key] = savedValue;
      svm.controllers[key]!.text = savedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuş Ayarları'),
        leading: Consumer<SettingsViewModel>(
          builder: (context, value, child) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(value.buttonOptions);
            },
          ),
        ),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, ref, child) => ListView.builder(
          itemCount: ref.buttonOptions.length,
          itemBuilder: (context, index) {
            String key = ref.buttonOptions.keys.elementAt(index);
            return ListTile(
              title: Text(key),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller: ref.controllers[key],
                  decoration: const InputDecoration(
                    hintText: 'Değer girin',
                  ),
                  onChanged: (value) {
                    ref.buttonOptions[key] = value;
                    ref.saveButtonOption(key, value);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

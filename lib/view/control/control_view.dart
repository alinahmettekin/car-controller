import 'package:carcontrol_mobx/core/constants/text_constants.dart';
import 'package:carcontrol_mobx/view/control/control_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';

class ControlView extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothConnection connection;

  const ControlView({super.key, required this.device, required this.connection});

  @override
  // ignore: library_private_types_in_public_api
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  String _direction = "Dur";
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

  @override
  void initState() {
    super.initState();
    final cvm = Provider.of<ControlViewModel>(context, listen: false);
    cvm.loadButtonOptions();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget _buildButton(String label, IconData icon) {
    final cvm = Provider.of<ControlViewModel>(context, listen: true);
    return ElevatedButton(
      onPressed: () => cvm.sendCommand(buttonOptions[label] ?? ''),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12), // Padding'i azalttık
        backgroundColor: Colors.blue,
        minimumSize: const Size(50, 50), // Minimum boyutu belirledik
      ),
      child: Icon(icon, size: 20), // İkon boyutunu küçülttük
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          '${widget.device.name} ${TextConstants.controlLabel}',
          style: const TextStyle(fontSize: 17),
        ),
        actions: [
          Consumer<ControlViewModel>(
            builder: (context, value, child) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () async {
                final updatedOptions = await value.showOptionsScreen(context, buttonOptions);
                buttonOptions = updatedOptions;
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Sol taraf - Joystick
          Positioned(
            left: 50,
            top: 100,
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Consumer<ControlViewModel>(
                    builder: (context, value, child) => Joystick(
                      mode: JoystickMode.all,
                      listener: (details) {
                        setState(() {
                          if (details.x > 0.5) {
                            _direction = "Sağ";
                            value.sendCommand(buttonOptions['Sağ'] ?? '');
                          } else if (details.x < -0.5) {
                            _direction = "Sol";
                            value.sendCommand(buttonOptions['Sol'] ?? '');
                          } else if (details.y > 0.5) {
                            _direction = "Geri";
                            value.sendCommand(buttonOptions['Geri'] ?? '');
                          } else if (details.y < -0.5) {
                            _direction = "İleri";
                            value.sendCommand(buttonOptions['İleri'] ?? '');
                          } else {
                            _direction = "Dur";
                            value.sendCommand(buttonOptions['Dur'] ?? '');
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(_direction, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          // Sağ alt - Eşkenar dörtgen butonlar
          Positioned(
            right: 50,
            bottom: 10,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 40,
                    top: 100,
                    child: _buildButton('Buton 1', Icons.lightbulb),
                  ),
                  Positioned(
                    left: 0,
                    top: 150,
                    child: _buildButton('Buton 2', Icons.volume_up),
                  ),
                  Positioned(
                    right: 20,
                    top: 100,
                    child: _buildButton('Buton 3', Icons.speed),
                  ),
                  Positioned(
                    left: 90,
                    bottom: 0,
                    child: _buildButton('Buton 4', Icons.settings),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

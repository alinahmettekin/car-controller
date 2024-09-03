import 'package:carcontrol_mobx/view/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Uzaktan Araç Kontrol',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              Consumer<HomeViewModel>(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: ref.isScanning ? null : ref.scanDevices,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ref.isScanning
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _animationController.value * 2 * 3.14,
                                      child: child,
                                    );
                                  },
                                  child: const Icon(Icons.refresh),
                                ),
                                const SizedBox(width: 10),
                                const Text('Taranıyor...'),
                              ],
                            )
                          : const Text('Cihazları Tara'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Consumer<HomeViewModel>(
                builder: (BuildContext context, HomeViewModel value, Widget? child) {
                  return Expanded(
                    child: value.devices.isEmpty
                        ? const Center(
                            child: Text('Henüz cihaz bulunamadı.'),
                          )
                        : ListView.builder(
                            itemCount: value.devices.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                child: ListTile(
                                  leading: const Icon(Icons.bluetooth, color: Colors.blue),
                                  title: Text(value.devices[index].name ?? 'Bilinmeyen Cihaz'),
                                  subtitle: Text(value.devices[index].address),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () => value.connectToDevice(value.devices[index], context),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

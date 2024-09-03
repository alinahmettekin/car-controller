import 'dart:developer';

import 'package:carcontrol_mobx/core/constants/text_constants.dart';
import 'package:carcontrol_mobx/core/helper/dialog_helper.dart';
import 'package:carcontrol_mobx/core/helper/route_helper.dart';
import 'package:carcontrol_mobx/view/control/control_view.dart';
import 'package:carcontrol_mobx/view/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final cvm = context.read<HomeViewModel>();
    cvm.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    final cvm = context.read<HomeViewModel>();
    cvm.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          TextConstants.distanceControlText,
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
                                  animation: ref.animationController,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: ref.animationController.value * 2 * 3.14,
                                      child: child,
                                    );
                                  },
                                  child: const Icon(Icons.refresh),
                                ),
                                const SizedBox(width: 10),
                                const Text(TextConstants.scanningText),
                              ],
                            )
                          : const Text(TextConstants.scanDevicesText),
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
                            child: Text(TextConstants.noDevicesText),
                          )
                        : ListView.builder(
                            itemCount: value.devices.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                child: ListTile(
                                  leading: const Icon(Icons.bluetooth, color: Colors.blue),
                                  title: Text(value.devices[index].name ?? TextConstants.unknownDevice),
                                  subtitle: Text(value.devices[index].address),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    try {
                                      value.connectToDevice(value.devices[index], context);
                                      if (value.connection == null) {
                                        DialogHelper.connectDialog(
                                            context, "Hata", "${value.devices[index].name}'e bağlanılamadı");
                                      } else {
                                        RouteHelper.pop(context); // Dialog'u kapat
                                        RouteHelper.push(context,
                                            ControlView(device: value.devices[index], connection: value.connection!));
                                      }
                                    } catch (e) {
                                      RouteHelper.pop(context); // Dialog'u kapat
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Bağlantı başarısız: $e')),
                                      );
                                      log(e.toString());
                                    }
                                  },
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

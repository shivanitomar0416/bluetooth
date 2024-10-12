import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bluetooth/blue_controller.dart';
// Ensure this file exists and is correctly implemented

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE Scanner"),
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(() { // Use Obx to listen for changes
                    return ListView.builder(
                      itemCount: controller.scanResults.length,
                      itemBuilder: (context, index) {
                        final data = controller.scanResults[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(data.device.name.isNotEmpty
                                ? data.device.name
                                : 'Unnamed Device'),
                            subtitle: Text(data.device.id.id),
                            trailing: Text(data.rssi.toString()),
                            onTap: () => controller.connectToDevice(data.device),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await controller.scanDevices();
                  },
                  child: const Text("SCAN"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs; // Observable list

  // Start scanning for devices
  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        ble.startScan(timeout: const Duration(seconds: 15));

        // Listen for scan results
        ble.scanResults.listen((results) {
          scanResults.assignAll(results); // Update observable list
        });

        // Stop scanning after the timeout
        await Future.delayed(const Duration(seconds: 15));
        ble.stopScan();
      }
    }
  }

  // Connect to the selected device
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(timeout: const Duration(seconds: 15));
    device.state.listen((state) {
      if (state == BluetoothDeviceState.connected) {
        print("Device connected: ${device.name}");
      } else if (state == BluetoothDeviceState.disconnected) {
        print("Device disconnected");
      }
    });
  }
}

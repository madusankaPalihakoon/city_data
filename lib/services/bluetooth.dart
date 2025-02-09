import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  StreamSubscription? _scanningStateSubscription;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    initPlatformState();
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('City Data'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Bluetooth State"),
            subtitle: Text(
              _adapterState.name == "off" ? "Tap to enable" : "Tap to disable",
            ),
            trailing: Text(_adapterState.name),
            leading: const Icon(Icons.settings_bluetooth),
            onTap: () => _flutterBlueClassicPlugin.turnOn(),
          ),
          const Divider(),
          if (scanResults.isEmpty)
            const Center(child: Text("No devices found yet"))
          else
            for (var (index, result) in scanResults.indexed)
              ListTile(
                title: Text("${result.name ?? "???"} (${result.address})"),
                subtitle: Text(
                    "Bondstate: ${result.bondState.name}, Device type: ${result.type.name}"),
                trailing: index == _connectingToIndex
                    ? const CircularProgressIndicator()
                    : Text("${result.rssi} dBm"),
                onTap: () async {
                  BluetoothConnection? connection;
                  setState(() => _connectingToIndex = index);
                  try {
                    connection =
                        await _flutterBlueClassicPlugin.connect(result.address);
                    if (!this.context.mounted) return;
                    if (connection != null && connection.isConnected) {
                      if (mounted) setState(() => _connectingToIndex = null);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceScreen()));
                    }
                  } catch (e) {
                    if (mounted) setState(() => _connectingToIndex = null);
                    if (kDebugMode) print(e);
                    connection?.dispose();
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(
                            content: Text("Error connecting to device")));
                  }
                },
              )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_isScanning) {
            _flutterBlueClassicPlugin.stopScan();
          } else {
            _scanResults.clear();
            _flutterBlueClassicPlugin.startScan();
          }
        },
        label: Text(
          _adapterState.name == "off"
              ? "Please enable Bluetooth First!"
              : (_isScanning ? "Scanning..." : "Start device scan"),
        ),
        icon: Icon(_isScanning ? Icons.bluetooth_searching : Icons.bluetooth),
      ),
    );
  }
}

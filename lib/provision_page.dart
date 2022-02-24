import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshsample/data/bluetooth_device.dart';

class ProvisionPage extends StatefulWidget {
  final BluetoothDevice device;

  const ProvisionPage(this.device, {Key? key}) : super(key: key);

  @override
  State<ProvisionPage> createState() => _ProvisionPageState();
}

class _ProvisionPageState extends State<ProvisionPage> {
  static const platform = MethodChannel('samples.flutter.dev/bluetoothConnect');
  bool isConnected = false;
  bool isIdentified = false;

  @override
  void initState() {
    super.initState();
  }

  connectDevice() async {
    bool res = await platform
        .invokeMethod('connectDevice', {'address': widget.device.address});
    setState(() {
      isConnected = res;
    });
  }

  identify() async {
    bool res = await platform.invokeMethod('identify');
    setState(() {
      isIdentified = res;
    });
  }

  provision() async {
    await platform.invokeMethod('provision');
  }

  reset() async {
    await platform.invokeMethod('resetNode');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('name: ' + (widget.device.name ?? '')),
              Text('address: ' + (widget.device.address ?? '')),
              Text('alias: ' + (widget.device.alias ?? '')),
              Text('bondState: ' + widget.device.bondState.toString()),
              Text('type: ' + widget.device.type.toString()),
              TextButton(
                onPressed: () {
                  connectDevice();
                },
                child: const Text('connect'),
              ),
              isConnected
                  ? TextButton(
                      onPressed: () {
                        identify();
                      },
                      child: const Text('identify'),
                    )
                  : Container(),
              isIdentified
                  ? TextButton(
                      onPressed: () {
                        provision();
                      },
                      child: const Text('provision'),
                    )
                  : Container(),
              TextButton(
                onPressed: () {
                  reset();
                },
                child: const Text('reset'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshsample/data/bluetooth_device.dart';
import 'package:meshsample/provision_page.dart';
import 'package:meshsample/provisioned_nodes_page.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanNodesPage extends StatefulWidget {
  @override
  State<ScanNodesPage> createState() => _ScanNodesPageState();
}

class _ScanNodesPageState extends State<ScanNodesPage> {
  static const eventPlatform = EventChannel('samples.flutter.dev/bluetoothScan');
  String data = 'no';
  List<BluetoothDevice> devices = [];

  void scanUnprovisionedNodes() async {
    eventPlatform
        .receiveBroadcastStream({'isProvisioned': false}).listen((event) {
      if (event != null) {
        List<BluetoothDevice> res = [];
        for (Map<dynamic, dynamic> data in event) {
          res.add(BluetoothDevice.fromMap(data));
        }
        setState(() {
          // BluetoothDevice device = BluetoothDevice.fromMap(event);
          // // data = data + event;
          // if (!devices.any((element) => element.address == device.address)) {
          //   // 여기서 리스트에 중복되는 (contains는 안통함)address 있으면 추가하지 않기
          //   devices.add(device);
          // }
          devices = res;
        });
      }
    });
  }

  void scanProvisionedNodes() async {
    eventPlatform
        .receiveBroadcastStream({'isProvisioned': true}).listen((event) {
      if (event != null) {
        List<BluetoothDevice> res = [];
        // for (Map<dynamic, dynamic> data in event) {
        for (Map<dynamic, dynamic> data in event) {
          res.add(BluetoothDevice.fromMap(data));
        }
        setState(() {
          // BluetoothDevice device = BluetoothDevice.fromMap(event);
          // // data = data + event;
          // if (!devices.any((element) => element.address == device.address)) {
          //   // 여기서 리스트에 중복되는 (contains는 안통함)address 있으면 추가하지 않기
          //   devices.add(device);
          // }
          devices = res;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    var locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }
    var bluetoothStatus = await Permission.bluetooth.status;
    if (!bluetoothStatus.isGranted) {
      await Permission.bluetooth.request();
    }
    var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
    if (!bluetoothConnectStatus.isGranted) {
      await Permission.bluetoothConnect.request();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app'),
        actions: [
          IconButton(
            onPressed: () {
              scanProvisionedNodes();
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              scanUnprovisionedNodes();
            },
            icon: Icon(Icons.cancel),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return buildChildWidget(devices[index]);
        },
      ),
    );
  }

  Widget buildChildWidget(BluetoothDevice device) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProvisionPage(device)));
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Row(
          children: [
            const SizedBox(
              height: 50,
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name ?? ''),
                Text(device.address ?? ''),
                Text(device.alias ?? ''),
                Text(device.type.toString() ?? ''),
                Text(device.bondState.toString() ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

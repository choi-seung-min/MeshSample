import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshsample/data/bluetooth_device.dart';
import 'package:meshsample/data/provisioned_device.dart';
import 'package:meshsample/provision_page.dart';
import 'package:meshsample/scan_nodes_page.dart';

class ProvisionedNodesPage extends StatefulWidget {
  @override
  State<ProvisionedNodesPage> createState() => _ProvisionedNodesPageState();
}

class _ProvisionedNodesPageState extends State<ProvisionedNodesPage> {

  static const platform = MethodChannel('samples.flutter.dev/bluetoothConnect');
  List<ProvisionedDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _getProvisionedNodes();
  }

  _getProvisionedNodes() async {
    List<Object?> res = await platform.invokeMethod('getProvisionedNodes');
    List<ProvisionedDevice> data = [];
    for (dynamic obj in res) {
      data.add(ProvisionedDevice.fromMap(obj));
    }
    if (mounted) {
      setState(() {
        devices = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanNodesPage()));
              _getProvisionedNodes();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              await platform.invokeMethod('resetNetwork');
            },
            icon: Icon(Icons.delete),
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

  Widget buildChildWidget(ProvisionedDevice device) {
    return InkWell(
      onTap: () async {
        // await platform.invokeMethod('resetNode', {'uuid': device.uuid});
        // _getProvisionedNodes();
        await platform.invokeMethod('setSelectedNode', {'uuid': device.uuid});
        Map<dynamic, dynamic> rawBluetoothDevice = await platform.invokeMethod('getSelectedNode');
        BluetoothDevice bluetoothDevice = BluetoothDevice.fromMap(rawBluetoothDevice);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProvisionPage(bluetoothDevice)));
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
                Text(device.companyIdentifier.toString() ?? ''),
                Text(device.crpl.toString() ?? ''),
                Text(device.productIdentifier.toString() ?? ''),
                Text(device.sequenceNumber.toString() ?? ''),
                Text(device.meshUuid.toString() ?? ''),
                Text(device.nodeName.toString() ?? ''),
                Text(device.ttl.toString() ?? ''),
                Text(device.uniCastAddress.toString() ?? ''),
                Text(device.uuid.toString() ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

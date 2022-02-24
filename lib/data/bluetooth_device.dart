class BluetoothDevice {
  String? name;
  String? address;
  String? alias;
  int? type;
  // int? uuid;
  int? bondState;

  BluetoothDevice({
    this.name,
    this.address,
    this.alias,
    this.type,
    this.bondState,
  });

  factory BluetoothDevice.fromMap(Map<dynamic, dynamic> data) {
    return BluetoothDevice(
      name: data['name'],
      address: data['address'],
      alias: data['alias'],
      type: data['type'],
      bondState: data['bondState'],
    );
  }
}

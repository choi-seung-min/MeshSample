class UnprovisionedDevice {
  String? nodeName;
  String? uuid;
  int? ttl;
  int? uniCastAddress;

  UnprovisionedDevice({
    this.nodeName,
    this.uuid,
    this.ttl,
    this.uniCastAddress,
  });

  factory UnprovisionedDevice.fromMap(Map<dynamic, dynamic> data) {
    return UnprovisionedDevice(
      nodeName: data["nodeName"],
      uuid: data["uuid"],
      ttl: data['ttl'],
      uniCastAddress: data['uniCastAddress'],
    );
  }
}

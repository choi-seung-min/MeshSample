class ProvisionedDevice {
  int? companyIdentifier;
  int? crpl;
  int? productIdentifier;
  int? sequenceNumber;
  String? meshUuid;
  String? nodeName;
  int? ttl;
  int? uniCastAddress;
  String? uuid;

  ProvisionedDevice({
    this.companyIdentifier,
    this.crpl,
    this.productIdentifier,
    this.sequenceNumber,
    this.meshUuid,
    this.nodeName,
    this.ttl,
    this.uniCastAddress,
    this.uuid,
  });

  factory ProvisionedDevice.fromMap(Map<dynamic, dynamic> data) {
    return ProvisionedDevice(
      companyIdentifier: data['companyIdentifier'],
      crpl: data['crpl'],
      productIdentifier: data['productIdentifier'],
      sequenceNumber: data['sequenceNumber'],
      meshUuid: data['meshUuid'],
      nodeName: data['nodeName'],
      ttl: data['ttl'],
      uniCastAddress: data['uniCastAddress'],
      uuid: data['uuid'],
    );
  }
}

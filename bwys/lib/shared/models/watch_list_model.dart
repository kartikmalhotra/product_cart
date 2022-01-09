import 'package:bwys/utils/extensions/string_extensions.dart';

class ModemsModel {
  List<Modem>? modems;

  ModemsModel({this.modems});

  ModemsModel.fromJson(Map<String, dynamic> json) {
    if (json['modems'] != null) {
      modems = <Modem>[];
      json['modems'].forEach((v) {
        modems!.add(Modem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (modems != null) {
      data['modems'] = modems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modem {
  String? macAddress;
  String? accountNumber;
  String? address;
  bool? isRapidPollerActive;

  Modem({
    this.macAddress,
    this.accountNumber,
    this.address,
    this.isRapidPollerActive,
  });

  Modem.fromJson(Map<String, dynamic> json) {
    if (json['mac_address']?.isNotEmpty ?? false) {
      macAddress =
          (json['mac_address'] as String).covertMACIntoDisplayMACFormat();
    }
    macAddress = macAddress ?? '--';
    accountNumber = json['account_number'];
    if (accountNumber?.isEmpty ?? true) {
      accountNumber = '--';
    }
    address = json['address'];
    if (address?.isEmpty ?? true) {
      address = '--';
    }
    isRapidPollerActive = json['is_rapid_poller_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mac_address'] = macAddress;
    data['account_number'] = accountNumber;
    data['address'] = address;
    data['is_rapid_poller_active'] = isRapidPollerActive;
    return data;
  }
}

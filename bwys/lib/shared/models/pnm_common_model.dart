import 'dart:convert';
import 'dart:ui';

/// Common Enums
enum ImageDataType { file_path, uint8_list }

/// Model Class for Chips - count and color
class ChipsCountMeta {
  int? count;
  Color? color;

  ChipsCountMeta({this.count, this.color});
}

/// ******************************************************
///         CMTS BreadCrumb Model
/// ******************************************************
class CMTSBreadCrumbModel {
  Data? data;

  CMTSBreadCrumbModel({this.data});

  CMTSBreadCrumbModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    return data;
  }
}

class Data {
  String? name;
  Name? zone;
  Name? region;
  Name? hub;

  Data({
    this.name,
    this.zone,
    this.region,
    this.hub,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    zone = json['Zone'] != null ? Name.fromJson(json['Zone']) : null;
    region = json['Region'] != null ? Name.fromJson(json['Region']) : null;
    hub = json['Hub'] != null ? Name.fromJson(json['Hub']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (zone != null) {
      data['Zone'] = zone!.toJson();
    }
    if (region != null) {
      data['Region'] = region!.toJson();
    }
    if (hub != null) {
      data['Hub'] = hub!.toJson();
    }

    return data;
  }
}

class Name {
  String? name;

  Name({this.name});

  Name.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;

    return data;
  }
}

/// This is the model class of Subscriber information
class SubscriberInfo {
  String? accountNumber;
  String? address;
  String? address2;
  String? displayAddress;
  String? city;
  String? country;
  String? firstName;
  String? middleName;
  String? lastName;
  String? displayName;
  num? latitude;
  num? longitude;
  String? phoneNumber;
  String? state;
  String? zip;

  SubscriberInfo({
    this.accountNumber,
    this.address,
    this.address2,
    this.city,
    this.country,
    this.firstName,
    this.middleName,
    this.lastName,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.state,
    this.zip,
  });

  SubscriberInfo.fromJson(Map<String, dynamic> json) {
    accountNumber = getDisplayValue(json['account_number']);
    address = json['address'];
    address2 = json['address2'];
    displayAddress = address?.trim().isNotEmpty ?? false
        ? "${address!.trim()}${address2?.trim().isNotEmpty ?? false ? ', ${address2!.trim()}' : ''}"
        : (address2?.trim().isNotEmpty ?? false ? address2!.trim() : '--');
    city = getDisplayValue(json['city']);
    country = getDisplayValue(json['country']);
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    displayName = firstName?.isNotEmpty ?? false
        ? "$firstName${(lastName?.isNotEmpty ?? false ? " $lastName" : "")}"
        : (lastName?.isNotEmpty ?? false ? lastName : "--");
    latitude = json['latitude'];
    longitude = json['longitude'];
    phoneNumber = getDisplayValue(json['phone_number']);
    state = getDisplayValue(json['state']);
    zip = getDisplayValue(json['zip']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['account_number'] = accountNumber;
    data['address'] = address;
    data['address2'] = address2;
    data['display_address'] = displayAddress;
    data['city'] = city;
    data['country'] = country;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone_number'] = phoneNumber;
    data['state'] = state;
    data['zip'] = zip;

    return data;
  }
}

/// ******************************************************
///         Sorting Data Model
/// ******************************************************

class SortingData {
  SortingOptions? sortingOptions;

  SortingData({this.sortingOptions});

  SortingData.fromJson(Map<String, dynamic> json) {
    sortingOptions = json['sorting_data'] != null
        ? SortingOptions.fromJson(json['sorting_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (sortingOptions != null) {
      data['sorting_data'] = sortingOptions!.toJson();
    }
    return data;
  }

  SortingData clone() {
    final String jsonString = json.encode(this);
    final jsonResponse = json.decode(jsonString);

    return SortingData.fromJson(jsonResponse as Map<String, dynamic>);
  }
}

class SortingOptions {
  List<SortingItem>? sortingOptions;

  SortingOptions({this.sortingOptions});

  SortingOptions.fromJson(Map<String, dynamic> json) {
    if (json['sort_options'] != null) {
      sortingOptions = <SortingItem>[];
      json['sort_options'].forEach((v) {
        sortingOptions!.add(SortingItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (sortingOptions != null) {
      data['sort_options'] = sortingOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SortingItem {
  bool? orderAsc; // null - no order, true - ascending, false - descending
  String? label;

  SortingItem({this.orderAsc, this.label});

  SortingItem.fromJson(Map<String, dynamic> json) {
    orderAsc = json['order_asc'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_asc'] = orderAsc;
    data['label'] = label;
    return data;
  }
}

/* 
  ****************************************************************************** 
  ********************* Common methods utilised in this file *******************
  ****************************************************************************** 
*/

/// This function checks for empty string and return "--" or else the string
/// will be returned
String getDisplayValue(String? value) {
  if (value == null || value.isEmpty) {
    return "--";
  }

  return value.trim();
}

class NotificationUpdateData {
  int? notificationId;
  bool? isRead;

  NotificationUpdateData({
    this.notificationId,
    this.isRead,
  });

  @override
  bool operator ==(other) {
    return other is NotificationUpdateData &&
        other.notificationId == notificationId &&
        other.isRead == isRead;
  }

  @override
  int get hashCode => super.hashCode;

}

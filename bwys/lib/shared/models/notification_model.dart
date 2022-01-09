import 'dart:convert';

class NotificationData {
  String? id;
  String? title;
  String? message;
  Payload? payload;

  NotificationData({this.title, this.message, this.payload});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    payload = json['payload'] != null
        ? Payload.fromJson(jsonDecode(json['payload']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? appDestination;
  String? woId;

  Payload({this.appDestination, this.woId});

  Payload.fromJson(Map<String, dynamic> json) {
    appDestination = json['app_destination']?.toString();
    woId = json['wo_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['app_destination'] = appDestination;
    data['wo_id'] = woId;
    return data;
  }
}

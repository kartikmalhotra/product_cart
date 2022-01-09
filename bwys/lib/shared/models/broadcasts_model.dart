class BroadcastsModel {
  List<Broadcast>? data;

  BroadcastsModel({this.data});

  BroadcastsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Broadcast>[];
      json['data'].forEach((v) {
        data!.add(Broadcast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Broadcast {
  int? id;
  String? message;
  String? messageType;
  String? startTime;
  String? endTime;

  Broadcast(
      {this.id, this.message, this.messageType, this.startTime, this.endTime});

  Broadcast.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    messageType = json['message_type'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['message'] = message;
    data['message_type'] = messageType;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

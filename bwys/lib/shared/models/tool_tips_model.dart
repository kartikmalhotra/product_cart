class ToolTipsData {
  List<ToolTip>? list;

  ToolTipsData({this.list});

  ToolTipsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      list = <ToolTip>[];
      json['data'].forEach((v) {
        list!.add(ToolTip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (list != null) {
      data['data'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToolTip {
  int? id;
  String? name;
  String? displayName;
  String? content;

  ToolTip({this.id, this.name, this.displayName, this.content});

  ToolTip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['display_name'] = displayName;
    data['content'] = content;
    return data;
  }
}

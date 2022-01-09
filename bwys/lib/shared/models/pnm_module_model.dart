class PNMModulesModel {
  List<Modules>? modules;

  PNMModulesModel({this.modules});

  PNMModulesModel.fromJson(Map<String, dynamic> json) {
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add(Modules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (modules != null) {
      data['modules'] = modules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modules {
  int? id;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Modules({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PNMDashboardModuleModel {
  bool? biDashboard;
  bool? cmtsOverview;
  bool? installNewCm;
  bool? map;
  bool? myAccount;
  bool? usAnalyzer;
  bool? modemDetails;
  bool? workOrder;
  bool? gamification;
  bool? usMonitor;
  bool? geocode;
  bool? rxmer;
  bool? spectra;
  bool? syncMobileApp;
  bool? ml;

  PNMDashboardModuleModel({
    this.biDashboard,
    this.cmtsOverview,
    this.installNewCm,
    this.map,
    this.myAccount,
    this.usAnalyzer,
    this.modemDetails,
    this.workOrder,
    this.gamification,
    this.usMonitor,
    this.geocode,
    this.rxmer,
    this.spectra,
    this.syncMobileApp,
    this.ml,
  });

  PNMDashboardModuleModel.fromJson(Map<String?, dynamic> json) {
    biDashboard = json['bi-dashboard'] ?? false;
    cmtsOverview = json['cmts-overview'] ?? false;
    installNewCm = json['install-new-cm'] ?? false;
    map = json['map'] ?? false;
    myAccount = json['my-account'] ?? false;
    usAnalyzer = json['us-analyzer'] ?? false;
    modemDetails = json['modem-details'] ?? false;
    workOrder = json['work-orders'] ?? false;
    gamification = json['gamification'] ?? false;
    usMonitor = json['us-monitor'] ?? false;
    geocode = json['geocode'] ?? false;
    rxmer = json['rxmer'] ?? false;
    spectra = json['spectra'] ?? false;
    syncMobileApp = json['sync-mobile-app'] ?? false;
    ml = json['ml'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bi-dashboard'] = biDashboard;
    data['cmts-overview'] = cmtsOverview;
    data['install-new-cm'] = installNewCm;
    data['map'] = map;
    data['my-account'] = myAccount;
    data['us-analyzer'] = usAnalyzer;
    data['modem-details'] = modemDetails;
    data['work-orders'] = workOrder;
    data['gamification'] = gamification;
    data['us-monitor'] = usMonitor;
    data['geocode'] = geocode;
    data['rxmer'] = rxmer;
    data['spectra'] = spectra;
    data['sync-mobile-app'] = syncMobileApp;
    data['ml'] = ml;
    return data;
  }
}

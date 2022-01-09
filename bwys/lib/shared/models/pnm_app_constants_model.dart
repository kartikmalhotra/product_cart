import 'package:bwys/config/application.dart';

class BWYSAppConstants {
  String? pnmNimbleLogoAltText;
  String? pnmAppTitle;
  String? lengthUnit;
  int? vTDRSensitivity;
  int? historyDeleteCycle;
  num? goodPortHealthScore;
  bool? subscriberSyncEnabled;
  String? mapAccessToken;
  num? modemFixesRadius;
  num? correlationFixesRadius;
  int? gamificationPointsResetCycle;
  String? gamificationCurrentCycleStartDate;
  String? displayGamificationCurrentCycleStartDate;
  String? displayGamificationCurrentCycleEndDate;
  RedThreshold? redThreshold;
  MapPinsColor? mapPinsColor;
  bool? isWebSocketEnabled;
  bool? allowTechnicianRebootCM;

  BWYSAppConstants({
    this.pnmNimbleLogoAltText,
    this.pnmAppTitle,
    this.lengthUnit,
    this.vTDRSensitivity,
    this.historyDeleteCycle,
    this.goodPortHealthScore,
    this.subscriberSyncEnabled,
    this.mapAccessToken,
    this.modemFixesRadius,
    this.correlationFixesRadius,
    this.gamificationPointsResetCycle,
    this.gamificationCurrentCycleStartDate,
    this.displayGamificationCurrentCycleStartDate,
    this.displayGamificationCurrentCycleEndDate,
    this.redThreshold,
    this.mapPinsColor,
    this.isWebSocketEnabled,
    this.allowTechnicianRebootCM,
  });

  BWYSAppConstants.fromJson(Map<String, dynamic> json) {
    pnmNimbleLogoAltText =
        json['PNM_NIMBLE_LOGO_ALT_TEXT'] ?? "Nimble This PNM Application";
    pnmAppTitle = json['PNM_APP_TITLE'] ?? "Nimble This PNM Application";
    lengthUnit = (json['LENGTH_UNIT'] != null && json['LENGTH_UNIT'] == "3.28")
        ? "Meter"
        : "Feet";
    vTDRSensitivity = json['vTDR_SENSITIVITY'] != null
        ? int.parse(json['vTDR_SENSITIVITY'])
        : -35;
    historyDeleteCycle = json['HISTORY_DELETE_CYCLE'] != null
        ? int.parse(json['HISTORY_DELETE_CYCLE'])
        : 7;
    goodPortHealthScore = json['GOOD_PORT_HEALTH_SCORE'] != null
        ? num.parse(json['GOOD_PORT_HEALTH_SCORE'])
        : 10.0;
    subscriberSyncEnabled = json['subscriber_sync_enabled'] ?? false;
    mapAccessToken = json['MAP_ACCESS_TOKEN'] ?? "hYOMjwTD8YLQz8m5tykO";
    modemFixesRadius = json['MODEM_FIXES_RADIUS'] != null
        ? num.parse(json['MODEM_FIXES_RADIUS'])
        : 1000;
    correlationFixesRadius = json['CORRELATION_FIXES_RADIUS'] != null
        ? num.parse(json['CORRELATION_FIXES_RADIUS'])
        : 5000;
    gamificationPointsResetCycle =
        json['GAMIFICATION_POINTS_RESET_CYCLE'] ?? 12;
    gamificationCurrentCycleStartDate =
        json['GAMIFICATION_CURRENT_CYCLE_START_DATE'] ?? '';

    displayGamificationCurrentCycleStartDate =
        gamificationCurrentCycleStartDate!.isNotEmpty
            ? Application.timezoneService!
                .getDateFromUTC(gamificationCurrentCycleStartDate!)
            : '';
    displayGamificationCurrentCycleEndDate =
        gamificationCurrentCycleStartDate!.isNotEmpty
            ? Application.timezoneService!.getDateFromUTC(Application
                .timezoneService!
                .addMonths(DateTime.parse(gamificationCurrentCycleStartDate!),
                    gamificationPointsResetCycle!)
                .toString())
            : '';
    redThreshold = RedThreshold.fromJson(json);
    mapPinsColor = json['map_pins_color'] != null
        ? MapPinsColor.fromJson(json['map_pins_color'])
        : MapPinsColor.fromJson({});
    isWebSocketEnabled =
        json['WEB_SOCKET_ENABLED'] != null && json['WEB_SOCKET_ENABLED'] == "1";
    allowTechnicianRebootCM = json['ALLOW_TECHNICIAN_REBOOT_CM'] != null &&
        json['ALLOW_TECHNICIAN_REBOOT_CM'] == "1";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['PNM_NIMBLE_LOGO_ALT_TEXT'] = pnmNimbleLogoAltText;
    data['PNM_APP_TITLE'] = pnmAppTitle;
    data['LENGTH_UNIT'] = lengthUnit;
    data['vTDR_SENSITIVITY'] = vTDRSensitivity;
    data['HISTORY_DELETE_CYCLE'] = historyDeleteCycle;
    data['GOOD_PORT_HEALTH_SCORE'] = goodPortHealthScore;
    data['subscriber_sync_enabled'] = subscriberSyncEnabled;
    data['MAP_ACCESS_TOKEN'] = mapAccessToken;
    data['MODEM_FIXES_RADIUS'] = modemFixesRadius;
    data['CORRELATION_FIXES_RADIUS'] = correlationFixesRadius;
    data['GAMIFICATION_POINTS_RESET_CYCLE'] = gamificationPointsResetCycle;
    data['GAMIFICATION_CURRENT_CYCLE_START_DATE'] =
        gamificationCurrentCycleStartDate;

    if (mapPinsColor != null) {
      data['map_pins_color'] = mapPinsColor!.toJson();
    }

    return data;
  }
}

class RedThreshold {
  Downstream? downstream;
  Upstream? upstream;
  RxMER? rxmer;

  RedThreshold({
    this.downstream,
    this.upstream,
  });

  RedThreshold.fromJson(Map<String, dynamic> json) {
    downstream = Downstream.fromJson(json);
    upstream = Upstream.fromJson(json);
    rxmer = RxMER.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (downstream != null) {
      data['downstream'] = downstream!.toJson();
    }
    if (upstream != null) {
      data['upstream'] = upstream!.toJson();
    }
    if (rxmer != null) {
      data['rxmer'] = rxmer!.toJson();
    }

    return data;
  }
}

class RxMER {
  String? averageRxMER;
  String? modemEfficiency;

  RxMER({
    this.averageRxMER,
    this.modemEfficiency,
  });

  RxMER.fromJson(Map<String, dynamic> json) {
    averageRxMER = json['RED_THRESHOLD_RXMER_AVG'] ?? "<30";
    modemEfficiency = json['RED_THRESHOLD_RXMER_MODEM_EFF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['RED_THRESHOLD_AverageRxMER'] = averageRxMER;
    data['RED_THRESHOLD_ModemEfficiency'] = modemEfficiency;

    return data;
  }
}

class Downstream {
  String? cmCorrCW;
  String? cmUnCorrCW;
  String? cmRXPWR;
  String? cmMER;

  Downstream({
    this.cmCorrCW,
    this.cmUnCorrCW,
    this.cmRXPWR,
    this.cmMER,
  });

  Downstream.fromJson(Map<String, dynamic> json) {
    cmCorrCW = json['RED_THRESHOLD_CMDSCorrCW'];
    cmUnCorrCW = json['RED_THRESHOLD_CMDSUnCorrCW'];
    cmRXPWR = json['RED_THRESHOLD_CMDSRXPWR'];
    cmMER = json['RED_THRESHOLD_CMDSMER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['RED_THRESHOLD_CMDSCorrCW'] = cmCorrCW;
    data['RED_THRESHOLD_CMDSUnCorrCW'] = cmUnCorrCW;
    data['RED_THRESHOLD_CMDSRXPWR'] = cmRXPWR;
    data['RED_THRESHOLD_CMDSMER'] = cmMER;

    return data;
  }
}

class Upstream {
  String? cmCorrCW;
  String? cmUnCorrCW;
  String? cmTXPWR;
  String? cmMER;
  String? cmtsRxPWR;
  String? delay;
  String? mrLevel;
  String? mtc;
  String? pv;

  Upstream({
    this.cmCorrCW,
    this.cmUnCorrCW,
    this.cmTXPWR,
    this.cmMER,
    this.cmtsRxPWR,
    this.delay,
    this.mrLevel,
    this.mtc,
    this.pv,
  });

  Upstream.fromJson(Map<String, dynamic> json) {
    cmCorrCW = json['RED_THRESHOLD_CMUSCorrCW'];
    cmUnCorrCW = json['RED_THRESHOLD_CMUSUnCorrCW'];
    cmTXPWR = json['RED_THRESHOLD_CMUSTXPWR'];
    cmMER = json['RED_THRESHOLD_CMUSMER'];
    cmtsRxPWR = json['RED_THRESHOLD_CMTSRXPWR'];
    delay = json['RED_THRESHOLD_Delay'];
    mrLevel = json['RED_THRESHOLD_MRLevel'];
    mtc = json['RED_THRESHOLD_MTC'];
    pv = json['RED_THRESHOLD_PV'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['RED_THRESHOLD_CMUSCorrCW'] = cmCorrCW;
    data['RED_THRESHOLD_CMUSUnCorrCW'] = cmUnCorrCW;
    data['RED_THRESHOLD_CMUSTXPWR'] = cmTXPWR;
    data['RED_THRESHOLD_CMUSMER'] = cmMER;
    data['RED_THRESHOLD_CMTSRXPWR'] = cmtsRxPWR;
    data['RED_THRESHOLD_Delay'] = delay;
    data['RED_THRESHOLD_MRLevel'] = mrLevel;
    data['RED_THRESHOLD_MTC'] = mtc;
    data['RED_THRESHOLD_PV'] = pv;

    return data;
  }
}

class MapPinsColor {
  String? cmtsPin;
  String? downstreamCorrelation;
  String? highMonitoringFreq;
  String? immediateActionReq;
  String? invalid;
  String? noActionReq;
  String? nodePin;
  String? offline;
  String? qam256;
  String? qam1024;
  String? qam4096;
  String? qamLess256;
  String? rxmerCorrelation;
  String? unusedChannel;
  String? upstreamCorrelation;

  MapPinsColor({
    this.cmtsPin,
    this.downstreamCorrelation,
    this.highMonitoringFreq,
    this.immediateActionReq,
    this.invalid,
    this.noActionReq,
    this.nodePin,
    this.offline,
    this.qam256,
    this.qam1024,
    this.qam4096,
    this.qamLess256,
    this.rxmerCorrelation,
    this.unusedChannel,
    this.upstreamCorrelation,
  });

  MapPinsColor.fromJson(Map<String, dynamic> json) {
    cmtsPin = json['cmts_pin'] ?? "#0B5382";
    downstreamCorrelation = json['downstream_correlation'] ?? "#3285D8";
    highMonitoringFreq = json['high_monitoring_freq'] ?? "#DDC934";
    immediateActionReq = json['immediate_action_req'] ?? "#FF2D27";
    invalid = json['invalid'] ?? "#AFACAC";
    noActionReq = json['no_action_req'] ?? "#00C600";
    nodePin = json['node_pin'] ?? "#0B5484";
    offline = json['offline'] ?? "#000000";
    qam256 = json['qam_256'] ?? "#D1A872";
    qam1024 = json['qam_1024'] ?? "#D5CB6D";
    qam4096 = json['qam_4096'] ?? "#8CA26E";
    qamLess256 = json['qam_less_256'] ?? "#96544D";
    rxmerCorrelation = json['rxmer_correlation'] ?? "#3285D8";
    unusedChannel = json['unused_channel'] ?? "#585858";
    upstreamCorrelation = json['upstream_correlation'] ?? "#3285D8";
  }

  Map<String, String?> toJson() {
    final Map<String, String?> data = Map<String, String?>();
    data['cmts_pin'] = cmtsPin;
    data['downstream_correlation'] = downstreamCorrelation;
    data['high_monitoring_freq'] = highMonitoringFreq;
    data['immediate_action_req'] = immediateActionReq;
    data['invalid'] = invalid;
    data['no_action_req'] = noActionReq;
    data['node_pin'] = nodePin;
    data['offline'] = offline;
    data['qam_256'] = qam256;
    data['qam_1024'] = qam1024;
    data['qam_4096'] = qam4096;
    data['qam_less_256'] = qamLess256;
    data['rxmer_correlation'] = rxmerCorrelation;
    data['unused_channel'] = unusedChannel;
    data['upstream_correlation'] = upstreamCorrelation;
    return data;
  }
}

import 'dart:convert';
import 'dart:typed_data';


class AppUserProfileModel {
  String? firstName;
  String? lastName;
  bool? isLdapUser;
  int? userType;
  int? totalRewardPoints;
  int? totalImpFixed;
  int? currentCycleRewardPoints;
  int? currentCycleImpFixed;
  int? rank;
  UserSetting? userSetting;
  Uint8List? profileImage;

  AppUserProfileModel({
    this.firstName,
    this.lastName,
    this.isLdapUser,
    this.userType,
    this.totalRewardPoints,
    this.totalImpFixed,
    this.currentCycleRewardPoints,
    this.currentCycleImpFixed,
    this.rank,
    this.userSetting,
    this.profileImage,
  });

  AppUserProfileModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    isLdapUser = json['is_ldap_user'];
    userType = json['user_type'];
    totalRewardPoints = json['total_reward_points'];
    totalImpFixed = json['total_impairment_fixed'];
    currentCycleRewardPoints = json['current_cycle_rewards_points'];
    currentCycleImpFixed = json['current_cycle_impairment_fixed'];
    rank = json['rank'];
    userSetting = json['UserSetting'] != null
        ? UserSetting.fromJson(json['UserSetting'])
        : null;
    profileImage = json['profile_picture'] != null
        ? base64.decode(json['profile_picture']['file_data'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_ldap_user'] = isLdapUser;
    data['user_type'] = userType;
    data['total_reward_points'] = totalRewardPoints;
    data['total_imp_fixed'] = totalImpFixed;
    data['current_cycle_rewards_points'] = currentCycleRewardPoints;
    data['current_cycle_imp_fixed'] = currentCycleImpFixed;
    data['rank'] = rank;
    if (userSetting != null) {
      data['UserSetting'] = userSetting!.toJson();
    }

    return data;
  }
}

class UserSetting {
  int? timezoneId;
  bool? showCmtsDrilldown;
  Timezone? timezone;

  UserSetting({this.timezoneId, this.showCmtsDrilldown, this.timezone});

  UserSetting.fromJson(Map<String, dynamic> json) {
    timezoneId = json['timezone_id'];
    showCmtsDrilldown = json['show_cmts_drilldown'];
    timezone =
        json['Timezone'] != null ? Timezone.fromJson(json['Timezone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['timezone_id'] = timezoneId;
    data['show_cmts_drilldown'] = showCmtsDrilldown;
    if (timezone != null) {
      data['Timezone'] = timezone!.toJson();
    }
    return data;
  }
}

class Timezone {
  String? name;
  String? isoName;

  Timezone({this.name, this.isoName});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isoName = json['iso_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['iso_name'] = isoName;
    return data;
  }
}

class UserUpstreamColumns {
  ColumnStatus? nodeName;
  ColumnStatus? macAddress;
  ColumnStatus? freq;
  ColumnStatus? cmtxpwr;
  ColumnStatus? cmupsnr;
  ColumnStatus? cmcorrcw;
  ColumnStatus? cmuncorrcw;
  ColumnStatus? usRxPower;
  ColumnStatus? corr;
  ColumnStatus? mtc;
  ColumnStatus? mrlevel;
  ColumnStatus? delay;
  ColumnStatus? tdr;
  ColumnStatus? fartdr;
  ColumnStatus? cmonline;
  ColumnStatus? pollTime;

  UserUpstreamColumns({
    this.nodeName,
    this.macAddress,
    this.freq,
    this.cmtxpwr,
    this.cmupsnr,
    this.cmcorrcw,
    this.cmuncorrcw,
    this.usRxPower,
    this.corr,
    this.mtc,
    this.mrlevel,
    this.delay,
    this.tdr,
    this.fartdr,
    this.cmonline,
    this.pollTime,
  });

  UserUpstreamColumns.fromJson(Map<String, dynamic> json) {
    nodeName = json['node_name'] != null
        ? ColumnStatus.fromJson(json['node_name'])
        : ColumnStatus.fromJson({"is_checked": 0});
    macAddress = json['mac_address'] != null
        ? ColumnStatus.fromJson(json['mac_address'])
        : ColumnStatus.fromJson({"is_checked": 0});
    freq = json['freq'] != null
        ? ColumnStatus.fromJson(json['freq'])
        : ColumnStatus.fromJson({"is_checked": 0});
    cmtxpwr = json['cmtxpwr'] != null
        ? ColumnStatus.fromJson(json['cmtxpwr'])
        : ColumnStatus.fromJson({"is_checked": 0});
    cmupsnr = json['cmupsnr'] != null
        ? ColumnStatus.fromJson(json['cmupsnr'])
        : ColumnStatus.fromJson({"is_checked": 0});
    cmcorrcw = json['cmcorrcw'] != null
        ? ColumnStatus.fromJson(json['cmcorrcw'])
        : ColumnStatus.fromJson({"is_checked": 0});
    cmuncorrcw = json['cmuncorrcw'] != null
        ? ColumnStatus.fromJson(json['cmuncorrcw'])
        : ColumnStatus.fromJson({"is_checked": 0});
    usRxPower = json['us_rx_power'] != null
        ? ColumnStatus.fromJson(json['us_rx_power'])
        : ColumnStatus.fromJson({"is_checked": 0});
    corr = json['corr'] != null
        ? ColumnStatus.fromJson(json['corr'])
        : ColumnStatus.fromJson({"is_checked": 0});
    mtc = json['mtc'] != null
        ? ColumnStatus.fromJson(json['mtc'])
        : ColumnStatus.fromJson({"is_checked": 0});
    mrlevel = json['mrlevel'] != null
        ? ColumnStatus.fromJson(json['mrlevel'])
        : ColumnStatus.fromJson({"is_checked": 0});
    delay = json['delay'] != null
        ? ColumnStatus.fromJson(json['delay'])
        : ColumnStatus.fromJson({"is_checked": 0});
    tdr = json['tdr'] != null
        ? ColumnStatus.fromJson(json['tdr'])
        : ColumnStatus.fromJson({"is_checked": 0});
    fartdr = json['fartdr'] != null
        ? ColumnStatus.fromJson(json['fartdr'])
        : ColumnStatus.fromJson({"is_checked": 0});
    cmonline = json['cmonline'] != null
        ? ColumnStatus.fromJson(json['cmonline'])
        : ColumnStatus.fromJson({"is_checked": 0});
    pollTime = json['poll_time'] != null
        ? ColumnStatus.fromJson(json['poll_time'])
        : ColumnStatus.fromJson({"is_checked": 0});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (nodeName != null) {
      data['node_name'] = nodeName!.toJson();
    }
    if (macAddress != null) {
      data['mac_address'] = macAddress!.toJson();
    }
    if (freq != null) {
      data['freq'] = freq!.toJson();
    }
    if (cmtxpwr != null) {
      data['cmtxpwr'] = cmtxpwr!.toJson();
    }
    if (cmupsnr != null) {
      data['cmupsnr'] = cmupsnr!.toJson();
    }
    if (cmcorrcw != null) {
      data['cmcorrcw'] = cmcorrcw!.toJson();
    }
    if (cmuncorrcw != null) {
      data['cmuncorrcw'] = cmuncorrcw!.toJson();
    }
    if (usRxPower != null) {
      data['us_rx_power'] = usRxPower!.toJson();
    }
    if (corr != null) {
      data['corr'] = corr!.toJson();
    }
    if (mtc != null) {
      data['mtc'] = mtc!.toJson();
    }
    if (mrlevel != null) {
      data['mrlevel'] = mrlevel!.toJson();
    }
    if (delay != null) {
      data['delay'] = delay!.toJson();
    }
    if (tdr != null) {
      data['tdr'] = tdr!.toJson();
    }
    if (fartdr != null) {
      data['fartdr'] = fartdr!.toJson();
    }
    if (cmonline != null) {
      data['cmonline'] = cmonline!.toJson();
    }
    if (pollTime != null) {
      data['poll_time'] = pollTime!.toJson();
    }
    return data;
  }
}

class ColumnStatus {
  bool? isChecked;

  ColumnStatus({this.isChecked});

  ColumnStatus.fromJson(Map<String, dynamic> json) {
    isChecked = json['is_checked'] != null ? json['is_checked'] == 1 : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_checked'] = isChecked! ? 1 : 0;
    return data;
  }
}





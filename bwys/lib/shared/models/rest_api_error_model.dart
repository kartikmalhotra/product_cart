class RestAPIErrorModel {
  String? code;
  String? message;
  String? loginAttemptsRemaining;

  RestAPIErrorModel({
    this.code,
    this.message,
    this.loginAttemptsRemaining,
  });

  RestAPIErrorModel.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString();
    message = json['message'];
    loginAttemptsRemaining = json['remaining_attempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    data['remaining_attempts'] = loginAttemptsRemaining;
    return data;
  }
}

class RestAPIUnAuthenticationModel {
  int? code;
  String? message;
  int? loginAttemptsRemaining;

  RestAPIUnAuthenticationModel({
    this.code,
    this.message,
    this.loginAttemptsRemaining,
  });

  RestAPIUnAuthenticationModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    loginAttemptsRemaining = json['remaining_attempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    data['remaining_attempts'] = loginAttemptsRemaining;
    return data;
  }
}

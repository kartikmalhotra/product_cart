mixin ValidationMixin {
  bool isFieldEmpty(String? fieldValue) => fieldValue?.isEmpty ?? true;

  bool validateEmailAddress(String? email) {
    if (email == null) return false;
    return RegExp(AppRegExp.emailRegExp).hasMatch(email);
  }

  bool validatePassword(String? password) {
    if ((password == null) || (password.length < 8)) return false;
    return true;
  }

  bool validateNewAndConfirmPassword(
      String? newPassword, String? confirmPassword) {
    return newPassword == confirmPassword;
  }

  bool validateMacAddress(String? macAddress) {
    if (macAddress == null) return false;
    return RegExp(AppRegExp.macAddressRegExp)
        .hasMatch(macAddress.toLowerCase());
  }

  bool validateLatLong(String? coordinates) {
    if (coordinates == null) return false;
    return RegExp(AppRegExp.latLngRegExp).hasMatch(coordinates);
  }
}

abstract class AppRegExp {
  /// Validation expression for Email Address
  static String emailRegExp =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  /// Validation expression for MAC Address
  static String macAddressRegExp =
      r'^[0-9a-f]{2}([-:]?)[0-9a-f]{2}(\1[0-9a-f]{2}){4}$';

  /// validation express for Latitude and Longitude
  static String latLngRegExp =
      r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)\s*,\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$';
}

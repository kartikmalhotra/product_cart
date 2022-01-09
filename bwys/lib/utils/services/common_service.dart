import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart'
    show SystemChrome, DeviceOrientation;

class CommonService {
  /// Instance of [CommonService]
  static CommonService? _instance;
  final _base64SafeEncoder = const Base64Codec.urlSafe();

  CommonService._internal();

  /// Return the instance of CommonService
  static CommonService? getInstance() {
    if (_instance == null) {
      _instance = CommonService._internal();
    }

    return _instance;
  }

  static bool checkListEqual(List<dynamic>? list1, List<dynamic>? list2) {
    if (list1 != null && list2 != null && list1.length == list2.length) {
      for (int i = 0; i < list1.length; i++) {
        if (list1[i] != list2[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  static int createListHashCode(List<dynamic> data) {
    int hashCode = 1;
    for (int i = 0; i < data.length; i++) {
      hashCode = hashCode ^ data[i].hashCode;
    }
    return hashCode;
  }

  /// This function is used to encode the [String] into [base64SafeEncode] string
  String encodeStringToBase64UrlSafeString(String data) =>
      _base64SafeEncoder.encode(utf8.encode(data));

  /// This function is used to decode the [base64SafeEncode] String into [String]
  String decodeFromBase64UrlSafeEncodedString(String data) =>
      utf8.decode(_base64SafeEncoder.decode(data));

  /// This function converts the Given feet value into the meters
  /// Required value in [num]
  num convertFeetToMeters(num value) {
    return value * 0.3048;
  }

  /// This function converts the Given meter value into the Feet
  /// Required value in [num]
  num convertMetersToFeet(num value) {
    return value * 3.28084;
  }

  /// This function converts the Given meter value into the kilometers
  /// Required value in [num]
  num convertMetersToKilometer(num value) {
    return value * 0.001;
  }

  /// This function converts the Given meter value into the miles
  /// Required value in [num]
  num convertMetersToMiles(num value) {
    return value * 0.000621371;
  }

  /// This method converts the standard MAC format into the format in which it
  /// needs to be send in API request
  String convertMACIntoAPIFormat(String? mac) {
    String? _mac = mac;
    return _mac?.replaceAll(RegExp(r'[^\w\s]+'), '').toLowerCase() ?? '';
  }

  /// This method converts the work order id into display work order id format
  /// by appending WO- and preceding zeroes to make it six digit number appending
  /// to WO-
  /// If work order id is greater then or equal to 6 digits then we only append
  /// WO- to the existing id
  /// i.e If id=1 then work order displayed as [WO-000001]
  /// If id=123456 then work order displayed as [WO-123456]
  String convertWorkOrderToDisplayFormat(int? id) {
    if (id == null || id.isNegative) {
      return "--";
    }

    int _constantLength = 6;
    int _numberOfZeroes = _constantLength - id.toString().length;
    String _workOrderPrefix = 'WO-';
    for (int i = 1; i <= _numberOfZeroes; i++) {
      _workOrderPrefix = _workOrderPrefix + "0";
    }

    return _workOrderPrefix + '$id';
  }

  /// The function returns the string type for which the impairment is fixed.
  /// This function is called whenever the text for the fixed type has to be shown
  /// in UI in corresponding to the integer value of type received from API
  ///
  /// The returned string is the key of language JSON files
  String getImpairmentFixedType(int? type) {
    String fixType;

    switch (type) {
      case 1:
        fixType = 'modem_text';
        break;
      case 2:
        fixType = 'modem_spectra_imp_text';
        break;
      case 3:
        fixType = 'corr_grp_text';
        break;
      case 4:
        fixType = 'fiber_node_text';
        break;
      default:
        fixType = 'double_dash';
    }

    return fixType;
  }

  
  /// This function converts generated a unique file name for for work order
  /// files
  String generateWorkOrderUploadFileName(int? workOrderId) {
    return "wo_${workOrderId}_${DateTime.now().millisecondsSinceEpoch}";
  }

  /// This function generates the unique file name for the fixed impairment files
  String generateFixedImpairmentUploadFileName(int? fixedImpairmentId) {
    return "fi_${fixedImpairmentId}_${DateTime.now().millisecondsSinceEpoch}";
  }

  /// This function provides translation key for work order status text
  /// according to the current status int value
  String getWorkOrderStatusText(int? status) {
    String statusText;

    switch (status) {
      case 1:
        statusText = 'open';
        break;
      case 2:
        statusText = 'in-progress';
        break;
      case 3:
        statusText = 'closed';
        break;
      default:
        statusText = 'unknown';
    }

    return statusText;
  }

  Future<File> getImageFileFromAssets(String path) async {
    // Directory tempDirectory = await getTemporaryDirectory();

    // final file = File('${tempDirectory.path}$path');
    // file.createSync(recursive: true);

    // await file.writeAsBytes(byteData.buffer
    //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return File('');
  }

  /// This function returns the CMTS BreadCrumb / Hierarchy
  /// Request Param: [CMTSBreadCrumbModel]

  void setHorizontalOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void setVerticalOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// This function checks for whether the value lies in the range
  bool checkValueInRange(String value, String? range) {
    bool _liesInMin = true;
    bool _liesInMax = true;
    num? _value = num.tryParse(value);

    if (_value == null) {
      return true;
    }

    if (range?.isNotEmpty ?? false) {
      if (range!.contains(',')) {
        List<String> _rangeArray = range.split(',');

        /// Check for first index
        if (_rangeArray[0].contains('<')) {
          num? _min =
              num.tryParse(_rangeArray[0].replaceAll(RegExp(r'[<=>]'), ''));
          _liesInMin =
              _rangeArray[0].contains('=') ? _value > _min! : _value >= _min!;
        } else if (_rangeArray[0].contains('>')) {
          num? _max =
              num.tryParse(_rangeArray[0].replaceAll(RegExp(r'[<=>]'), ''));
          _liesInMax =
              _rangeArray[0].contains('=') ? _value < _max! : _value <= _max!;
        }

        /// Check for seconds index
        if (_rangeArray[1].contains('>')) {
          num? _max =
              num.tryParse(_rangeArray[1].replaceAll(RegExp(r'[<=>]'), ''));
          _liesInMax =
              _rangeArray[1].contains('=') ? _value < _max! : _value <= _max!;
        } else if (_rangeArray[1].contains('<')) {
          num? _min =
              num.tryParse(_rangeArray[1].replaceAll(RegExp(r'[<=>]'), ''));
          _liesInMin =
              _rangeArray[1].contains('=') ? _value > _min! : _value >= _min!;
        }
      } else if (range.contains('>')) {
        num? _max = num.tryParse(range.replaceAll(RegExp(r'[<=>]'), ''));
        _liesInMax = range.contains('=') ? _value < _max! : _value <= _max!;
      } else if (range.contains('<')) {
        num? _min = num.tryParse(range.replaceAll(RegExp(r'[<=>]'), ''));
        _liesInMin = range.contains('=') ? _value > _min! : _value >= _min!;
      }
    }

    return _liesInMin && _liesInMax;
  }
}

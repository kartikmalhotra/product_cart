import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/shared/models/upload_file_models.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        /// Explicitly returning true to avoid handshake exception
        return true;
      });
  }
}

class RestAPIService {
  static RestAPIService? _instance;
  static String? _pnmApiBaseUrl;

  RestAPIService._internal();

  static RestAPIService? getInstance() {
    if (_instance == null) {
      _instance = RestAPIService._internal();
    }
    if (_pnmApiBaseUrl == null) {
      _pnmApiBaseUrl = Application.storageService!.syncedAPIUrl;
    }

    return _instance;
  }

  /// Set the PNM API Base URL
  /// Called when setting syncing mobile app with other server
  set pnmAPIBaseUrlData(String? data) {
    _pnmApiBaseUrl = data;
  }

  Future<dynamic> requestCall(
      {required String? apiEndPoint,
      required RestAPIRequestMethods method,
      dynamic requestParmas,
      Map<String, dynamic>? replaceParam,
      bool isFileRequest = false}) async {
    if (_pnmApiBaseUrl == null) {
      _pnmApiBaseUrl = Application.storageService!.syncedAPIUrl;
    }

    String? _apiEndPoint = apiEndPoint;

    Map<String, String> _httpHeaders = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    /// Check whether to skip the authorization token in the requested [apiEndpoint]
    if (!AppConstants.skipAuthAPIs.contains(apiEndPoint)) {
      _httpHeaders[HttpHeaders.authorizationHeader] =
          "Bearer ${AppUser.userToken}";
    }

    /// Check if [replaceParam] is not null and [_apiEndPoint] is having [:] then modify the apiEndpoint for [GET] request
    if (replaceParam != null && _apiEndPoint!.contains(':')) {
      _apiEndPoint = _modifyAPIEndPoint(_apiEndPoint, replaceParam);
    }

    /// make the complete URL of API
    Uri _apiUrl = Uri.parse('$_pnmApiBaseUrl$_apiEndPoint');

    /// json encode the request params
    dynamic _requestParmas = json.encode(requestParmas);

    /// check the device OS for appending in request header
    String deviceType = Platform.isAndroid ? 'Android' : 'iOS';

    /// append the device OS and web app version and mobile app version in headers for monitoring purposes
    _httpHeaders[HttpHeaders.userAgentHeader] =
        'Mobile/DartPlatform||$deviceType||${Application.storageService!.syncedWebAppVersion}';

    var responseJson;

    switch (method) {
      case RestAPIRequestMethods.GET:
        try {
          final response = await http.get(_apiUrl, headers: _httpHeaders);
          responseJson =
              _returnResponse(response, isFileRequest: isFileRequest);
        } on SocketException {
          throw FetchDataException(0000,
              'No internet connection found, Please check your internet and try again!');
        } on FormatException {
          throw BadRequestException(0001,
              'Unable to process your request due to some failure, Please try again later!');
        } on http.ClientException {
          throw FetchDataException(0002,
              'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!');
        }
        break;
      case RestAPIRequestMethods.POST:
        try {
          final response = await http.post(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          throw FetchDataException(0000,
              'No internet connection found, Please check your internet and try again!');
        } on FormatException {
          throw BadRequestException(0001,
              'Unable to process your request due to some failure, Please try again later!');
        } on http.ClientException {
          throw FetchDataException(0002,
              'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!');
        }
        break;
      case RestAPIRequestMethods.PUT:
        try {
          final response = await http.put(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          throw FetchDataException(0000,
              'No internet connection found, Please check your internet and try again!');
        } on FormatException {
          throw BadRequestException(0001,
              'Unable to process your request due to some failure, Please try again later!');
        } on http.ClientException {
          throw FetchDataException(0002,
              'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!');
        }
        break;
      case RestAPIRequestMethods.DELETE:
        try {
          /// normal delete request without body
          if (requestParmas == null) {
            final response = await http.delete(_apiUrl, headers: _httpHeaders);
            responseJson = _returnResponse(response);
          } else {
            /// delete request with body
            final request = http.Request("DELETE", _apiUrl);
            request.headers.addAll(_httpHeaders);
            request.body = json.encode(requestParmas);
            final streamedResponse = await request.send();
            final response = await http.Response.fromStream(streamedResponse);
            responseJson = _returnResponse(response);
          }
        } on SocketException {
          throw FetchDataException(0000,
              'No internet connection found, Please check your internet and try again!');
        } on FormatException {
          throw BadRequestException(0001,
              'Unable to process your request due to some failure, Please try again later!');
        } on http.ClientException {
          throw FetchDataException(0002,
              'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!');
        }
        break;
      case RestAPIRequestMethods.PATCH:
        try {
          final response = await http.patch(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          throw FetchDataException(0000,
              'No internet connection found, Please check your internet and try again!');
        } on FormatException {
          throw BadRequestException(0001,
              'Unable to process your request due to some failure, Please try again later!');
        } on http.ClientException {
          throw FetchDataException(0002,
              'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!');
        }
        break;
      default:
        break;
    }
    return responseJson;
  }

  /// This function returns the apiEndPoints by modifying the Endpoint i.e by replacing the [:tmp] with actual content required for [GET] request
  String? _modifyAPIEndPoint(
      String? apiEndPoint, Map<String, dynamic> replaceParam) {
    String? _modifiedAPIEndPoint = apiEndPoint;
    replaceParam.forEach((key, value) {
      if (apiEndPoint!.contains(key)) {
        _modifiedAPIEndPoint =
            _modifiedAPIEndPoint!.replaceAll(':$key', value.toString());
      }
    });

    return _modifiedAPIEndPoint;
  }

  /// This function is used upload the file (Currently : image) to the server in the form of multipart/form-data
  Future<dynamic> multiPartRequestCall(
      {required String apiEndPoint,
      required String method,
      required List<UploadFile> files,
      Map<String, dynamic>? replaceParam}) async {
    if (_pnmApiBaseUrl == null) {
      _pnmApiBaseUrl = Application.storageService!.syncedAPIUrl;
    }

    String? _apiEndPoint = apiEndPoint;

    /// Check if [replaceParam] is not null and [_apiEndPoint] is having [:] then modify the apiEndpoint for [GET] request
    if (replaceParam != null && _apiEndPoint.contains(':')) {
      _apiEndPoint = _modifyAPIEndPoint(_apiEndPoint, replaceParam);
    }

    /// Make complete API URL
    String _apiUrl = '$_pnmApiBaseUrl$_apiEndPoint';

    /// Initialize the multipart request
    var _request = http.MultipartRequest(method, Uri.parse(_apiUrl));

    /// Add Authorization token in headers
    _request.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${AppUser.userToken}';

    /// check the device OS for appending in request header
    String deviceType = Platform.isAndroid ? 'Android' : 'iOS';

    /// append the device OS and web app version and mobile app version in headers for monitoring purposes
    _request.headers[HttpHeaders.userAgentHeader] =
        'Mobile/DartPlatform||$deviceType||${Application.storageService!.syncedWebAppVersion}';

    /// Add files to request
    for (final file in files) {
      /// Find the mime type of the selected file by looking at the header bytes of the file
      final _mimeTypeData =
          lookupMimeType(file.filePath, headerBytes: [0xFF, 0xD8])!.split('/');

      /// Attach the file in the request
      final _file = await http.MultipartFile.fromPath(
          file.fileName, file.filePath,
          contentType: MediaType(_mimeTypeData[0], _mimeTypeData[1]));

      _request.files.add(_file);
    }

    /// Send the request
    final http.Response response =
        await http.Response.fromStream(await _request.send());

    return _returnResponse(response);
  }

  dynamic _returnResponse(http.Response response,
      {bool isFileRequest = false}) {
    Map<String, dynamic> _responseBody =
        _getResponseBody(response, isFileRequest);

    switch (response.statusCode) {
      case 200:
      case 201:
        var returnJson = _responseBody['data'] ?? _responseBody;
        return returnJson;
      case 204:
        Map<String, bool> _returnMap = {'success': true};
        return _returnMap;
      case 400:
        throw BadRequestException(
            _responseBody['error']['code'], _responseBody['error']['message']);
      case 401:
        return RestAPIUnAuthenticationModel.fromJson(_responseBody['error']);
      case 403:
        throw UnAuthorisedException(
            _responseBody['error']['code'], _responseBody['error']['message']);
      default:
        throw BadRequestException(
            _responseBody['error']['code'], _responseBody['error']['message']);
    }
  }

  Map<String, dynamic> _getResponseBody(
      http.Response response, bool isFileRequest) {
    Map<String, dynamic> _responseBody = {};
    if (response.body.isNotEmpty && !isFileRequest) {
      /// decode the response
      var _jsonResponse = json.decode(response.body);

      /// Check if _responseBody is not Map and do not contains key ['data'] and ['error] then add that _responseBody with key 'data'
      /// Required for GIS API Call
      if (_jsonResponse is! Map ||
          (_jsonResponse['data'] == null && _jsonResponse['error'] == null)) {
        _responseBody = {'data': _jsonResponse};
      } else {
        _responseBody = _jsonResponse as Map<String, dynamic>;
      }
    } else if (response.body.isNotEmpty && isFileRequest) {
      String _base64String = base64.encode(response.bodyBytes);
      Uint8List _bytes = base64.decode(_base64String);
      _responseBody['file'] = _bytes;
    } else {
      _responseBody = {
        'error': {'code': 1111, 'message': 'Unexpected error'}
      };
    }
    return _responseBody;
  }

  Map<String, String> getErrorResponse(RestAPICallException e) {
    String errorString = e.toString();
    List<dynamic> errorArray = errorString.split(":::");
    Map<String, String> errorResponse = {
      "code": errorArray[0].toString(),
      "message": errorArray[1]
    };
    return errorResponse;
  }
}

class RestAPICallException implements Exception {
  final int? _errorCode;
  final String? _message;

  RestAPICallException([this._errorCode, this._message]);

  String toString() {
    return '$_errorCode:::$_message';
  }
}

class FetchDataException extends RestAPICallException {
  FetchDataException([int? errorCode, String? message])
      : super(errorCode, message);
}

class BadRequestException extends RestAPICallException {
  BadRequestException([int? errorCode, String? message])
      : super(errorCode, message);
}

class UnAuthenticationException extends RestAPICallException {
  UnAuthenticationException([int? errorCode, String? message])
      : super(errorCode, message);
}

class UnAuthorisedException extends RestAPICallException {
  UnAuthorisedException([int? errorCode, String? message])
      : super(errorCode, message);
}

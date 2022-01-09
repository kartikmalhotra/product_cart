import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class NativeAPIService {
  /// Instance of [CommonService]
  static NativeAPIService? _instance;

  /// Instance of Location
  static Location? _location;

  /// Instance of ImagePicker
  static ImagePicker? _imagePicker;

  NativeAPIService._internal();

  static NativeAPIService? getInstance() {
    if (_instance == null) {
      _instance = NativeAPIService._internal();
    }
    if (_location == null) {
      _location = Location();
    }
    if (_imagePicker == null) {
      _imagePicker = ImagePicker();
    }

    return _instance;
  }

  /// This function gets the list of Enrolled biometrcis present on device
  Future<List<BiometricType>> getEnrolledBiometrics() async {
    List<BiometricType> enrolledBiometrics = [];
    try {
      // enrolledBiometrics = await Application.localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {}
    return enrolledBiometrics;
  }

  /// ******************************************************
  ///
  ///         Image Upload Related Feature
  ///
  /// ******************************************************

  /// This function is used to pick image from the source provided [Camera] or [Gallery]
  Future<Map<String, dynamic>> pickImage(ImageSource source) async {
    try {
      XFile? _pickedFile = await _imagePicker!.pickImage(source: source);
      Map<String, dynamic> _imageFile;
      if (_pickedFile?.path.isNotEmpty ?? false) {
        _imageFile = {'image': File(_pickedFile?.path as String)};
      } else {
        _imageFile = {'error': 'error_no_image_selected'};
      }
      return _imageFile;
    } catch (e) {
      Map<String, dynamic> _error = {'error': e.toString()};
      return _error;
    }
  }

  /// Android system -- although very rarely -- sometimes kills the MainActivity after the image_picker finishes. This result in loss of data
  /// This is used to retrieve the lost data (image) by using the [image_picker] plugin
  Future<Map<String, dynamic>> retrieveLostImage(dynamic e) async {
    Map<String, dynamic> _lostImage;
    final LostDataResponse response = await _imagePicker!.retrieveLostData();

    if (response.isEmpty) {
      _lostImage = {'error': e};
    }

    /// Check if lost file is present and is only of type image
    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        _lostImage = await compressImage(File(response.file!.path));
      } else {
        _lostImage = {'error': e};
      }
    } else {
      _lostImage = {
        'error': response.exception != null ? response.exception!.code : e
      };
    }

    return _lostImage;
  }

  /// This function is used to compress the image size using plugin
  /// [flutter_image_compress] which is used to compress the image
  Future<Map<String, dynamic>> compressImage(File file) async {
    Map<String, dynamic> _compressedImage;
    final String _filePath = file.absolute.path;
    final int _lastIndex = _filePath.lastIndexOf('.');
    final String _targetPath =
        "${file.path}/compress_${DateTime.now()}${_filePath.substring(_lastIndex)}";

    final CompressFormat _compressFormat =
        _getCompressFormat(_filePath.substring(_lastIndex));

    /// Compress and Get file
    try {
      File? _compressedFile = await FlutterImageCompress.compressAndGetFile(
        _filePath,
        _targetPath,
        format: _compressFormat,
        quality: 15,
        minWidth: 1200,
        minHeight: 900,
      );

      _compressedImage = {'image': _compressedFile};

      return _compressedImage;
    } catch (e) {
      _compressedImage = {'error': e.toString()};
      return _compressedImage;
    }
  }

  CompressFormat _getCompressFormat(String? format) {
    if (format == null) {
      return CompressFormat.jpeg;
    }

    if (format.endsWith('.jpg') || format.endsWith('.jpeg')) {
      return CompressFormat.jpeg;
    } else if (format.endsWith('.png')) {
      return CompressFormat.png;
    } else if (format.endsWith('.heic')) {
      return CompressFormat.heic;
    }

    return CompressFormat.jpeg;
  }

  /// This is used to crop the image using plugin [image_cropper]
  Future<Map<String, dynamic>> cropImage(
      String imageSourcePath, String? toolBarTitle,
      {Color? toolBarColor}) async {
    Map<String, dynamic> _croppedImage;

    File? _croppedFile = await ImageCropper.cropImage(
        sourcePath: imageSourcePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: toolBarTitle,
            toolbarColor: toolBarColor ?? Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            activeControlsWidgetColor: toolBarColor ?? Colors.blue),
        iosUiSettings: IOSUiSettings(
          title: toolBarTitle,
        ));

    if (_croppedFile != null) {
      _croppedImage = {'image': _croppedFile};
    } else {
      _croppedImage = {'error': "error_no_image_selected"};
    }

    return _croppedImage;
  }

  /// ******************************************************
  ///
  ///         Geolocation Related Feature
  ///
  /// ******************************************************

  /// This function is used to return the bool value if location permission is given to the application
  Future<bool> getGeolocationPermissionStatus() async {
    try {
      return await requestPermission(Permission.location);
    } catch (_) {
      return false;
    }
  }

  /// This function is used to check whether the GPS is enabled on device or not
  Future<bool> checkGPSEnabled() async {
    try {
      bool _gpsEnabled = await _location!.serviceEnabled();

      /// Check if GPS is not enabled then allow the user to enable the GPS/ Location service
      if (!_gpsEnabled) {
        _gpsEnabled = await _location!.requestService();
      }

      return _gpsEnabled;
    } catch (_) {
      return false;
    }
  }

  /// This function is used to fetch the user current location provided with default [desiredAccuracy = LocationAccuracy.best]
  Future<Map<String, dynamic>> getCurrentLocation(
      {LocationAccuracy desiredAccuracy = LocationAccuracy.high}) async {
    /// Fetch the Current Location
    try {
      /// Change the location setting to [desiredAccuracy]
      await _location!.changeSettings(accuracy: desiredAccuracy);

      LocationData _currentLocation = await _location!.getLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () async {
          if (desiredAccuracy == LocationAccuracy.high) {
            /// Change the location setting to [LocationAccuracy.balanced]
            await _location!
                .changeSettings(accuracy: LocationAccuracy.balanced);

            /// Fetch the current location
            LocationData _currentLocation =
                await _location!.getLocation().timeout(
                      const Duration(seconds: 20),
                      onTimeout: (() => throw const FormatException()),
                    );

            return _currentLocation;
          } else {
            throw const FormatException();
          }
        },
      );
      return {'success': _currentLocation};
    } on PlatformException {
      return {'error': 'error_no_location_permission'};
    } on FormatException {
      return {'error': 'error_invalid_location_mode'};
    } catch (e) {
      if (desiredAccuracy == LocationAccuracy.high) {
        return await getCurrentLocation(
            desiredAccuracy: LocationAccuracy.balanced);
      } else {
        return {'error': 'error_location_not_found'};
      }
    }
  }

  /// Calculate the distance between two coordinates
  Map<String, dynamic> getDistanceBetween(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) {
    try {
      // double _distanceBetween = geolocator.Geolocator.distanceBetween(
      //     startLatitude, startLongitude, endLatitude, endLongitude);
      // return {'distance': _distanceBetween};
      return {'distance': 10.0};
    } catch (_) {
      return {'error': true};
    }
  }

  /// ******************************************************
  ///
  ///         Storage Permission Related Feature
  ///
  /// ******************************************************

  /// This function request for the storage permissions
  Future<bool> requestStoragePermission() async {
    return await requestPermission(Permission.storage);
  }

  /// ******************************************************
  ///
  ///         Permission handler Related Feature
  ///
  /// ******************************************************

  /// This function request for the permission related to native features.
  /// Request param: [PermissionGroup]
  Future<bool> requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }
}

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionManager {
  static requestCameraPermission(BuildContext context, VoidCallback onGranted,
      Function(String) onError) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      onGranted();
    } else if (status.isPermanentlyDenied) {
      onError('You have to grant camera permission');
    } else {
      // Permission denied, you can handle it gracefully or show a rationale and request again.
    }
  }

  static requestExternalStoragePermission(BuildContext context,
      VoidCallback onGranted, Function(String) onError) async {
    if (Platform.isIOS) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        onGranted();
      } else if (status.isPermanentlyDenied) {
        onError('You have to grant storage permission');
      } else {
        onError('You have to grant storage permission');
      }
    } else {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      var status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;

      if (status.isGranted) {
        onGranted();
      } else if (status.isPermanentlyDenied) {
        onError('You have to grant storage permission');
      } else {
        onError('You have to grant storage permission');
      }
    }
  }

  static requestGalleryPermission(BuildContext context, VoidCallback onGranted,
      Function(String) onError) async {
    onGranted();
    /*if(Platform.isAndroid){
      onGranted();
    }else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        onGranted();
      } else if (status.isPermanentlyDenied) {
        onError('You have to grant photos permission');
      } else {
        onError('You have to grant photos permission');
      }
    }*/
  }
}

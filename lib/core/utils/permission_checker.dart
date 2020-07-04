import 'dart:io';
import 'package:evoting/core/widgets/permission_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';

/// [PermissionChecker] class handle all permission checking stuff in fonepay app
/// You have to pass [BuildContext] which is used to display bottom sheet.
class PermissionChecker {
  //
  //

  /// [PermissionChecker] class contain functions which is used to check different
  /// permissions which is used by Fonepay app.
  ///
  /// [hasLocationPermission] function is used to check location permission.
  ///
  /// [hasCameraPermission] function is used to check camera permission.
  ///
  /// [hasGalleryPermission] function is used to check photos(IOS)/storage(Android) permission.

  /// [hasLocationPermission] function will return true if location permission is granted
  /// otherwise, return false. [hasLocationPermission] function has optional parameter [onlyOnce]
  /// which is of bool type. If [onlyOnce] is true permission will be asked only once for
  /// aplication active session.

  static Future<bool> hasLocationPermission(BuildContext context) async {
    //
    /// For android point of view this boolean flag is most important.
    /// Android will keep asking for permission until we check never ask again option.
    /// So to prevent apearing module bottom sheet we have store [isFirstTime] boolean flag
    /// in shared preference. At first isFirstTime will be false, as soon as user click specific
    /// button isFirstTime flag is set to true. After that isFirstTime value will be true untill user
    /// uninstall app.
    bool isFirstTime = await _isFirstTimeLocationRequest();

    // Current permission status for camera
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    final PermissionHandler permissionHandler = PermissionHandler();

    /// By default permission status is unknown in ios.
    /// So we have to ask permission for IOS from unknown status
    if (status == PermissionStatus.unknown) {
      await permissionHandler.requestPermissions([PermissionGroup.location]);
      status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);
    }

    if (status == PermissionStatus.denied) {
      if (Platform.isAndroid) {
        final bool show = await permissionHandler
            .shouldShowRequestPermissionRationale(PermissionGroup.location);

        /// If this is not first time click and if showing permission aleart box is false
        /// only then display bottom sheet else ask for permission
        if (!isFirstTime && !show) {
          PermissionDialog(
            permissionFor: 'location',
            context: context,
          );
          // _showModalSheetLocation(context);
        } else {
          await permissionHandler
              .requestPermissions([PermissionGroup.location]);
          status = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.location);
        }
      } else if (Platform.isIOS) {
        PermissionDialog(
          permissionFor: 'location',
          context: context,
        );
      }
    }

    if (status == PermissionStatus.restricted) {
      PermissionDialog(
        permissionFor: 'location',
        context: context,
      );
    }

    if (status == PermissionStatus.disabled) {
      PermissionDialog(
        permissionFor: 'location',
        context: context,
        disabled: Platform.isAndroid ? true : false,
      );
    }

    return status == PermissionStatus.granted;
  }

  /// [hasCameraPermission] function will return true if camera permission is granted
  /// otherwise, return false.
  static Future<bool> hasCameraPermission(BuildContext context) async {
    //

    /// Logic is similar to [hasLocationPermission] function so for more details
    ///  read comments from [hasLocationPermission] function.
    bool isFirstTime = await _isFirstTimeCameraRequest();

    // Current permission status for camera
    PermissionStatus status =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    final PermissionHandler permissionHandler = PermissionHandler();

    if (status == PermissionStatus.unknown) {
      await permissionHandler.requestPermissions([PermissionGroup.camera]);
      status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera);
    }

    if (status == PermissionStatus.denied) {
      if (Platform.isAndroid) {
        final bool show = await permissionHandler
            .shouldShowRequestPermissionRationale(PermissionGroup.camera);

        // At start [show] is false => Dont show dialogue
        // After denying show will be true => Dont show dialogue
        // If we check dont ask again show will be false => Show dialogue
        if (!isFirstTime && !show) {
          PermissionDialog(
            permissionFor: 'camera',
            context: context,
          );
        } else {
          await permissionHandler.requestPermissions([PermissionGroup.camera]);
          status = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.camera);
        }
      } else if (Platform.isIOS) {
        Navigator.of(context).pop();
        PermissionDialog(
          permissionFor: 'camera',
          context: context,
        );
      }
    }

    if (status == PermissionStatus.disabled ||
        status == PermissionStatus.restricted) {
      Navigator.of(context).pop();
      PermissionDialog(
        permissionFor: 'camera',
        context: context,
      );
    }

    return status == PermissionStatus.granted;
  }

  /// [hasGalleryPermission] function will return true if photos(IOS)/storage(Android)
  /// permission is granted otherwise, return false.
  static Future<bool> hasGalleryPermission(BuildContext context) async {
    //
    /// Check storage permission for android
    if (Platform.isAndroid) {
      //
      /// Logic is similar to [hasLocationPermission] function so for more details
      ///  read comments from [hasLocationPermission] function.
      bool isFirstTime = await _isFirstTimeGalleryRequest();

      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      final PermissionHandler permissionHandler = PermissionHandler();

      if (status == PermissionStatus.unknown) {
        await permissionHandler.requestPermissions([PermissionGroup.storage]);
        status = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
      }

      if (status == PermissionStatus.denied) {
        //

        final bool show = await permissionHandler
            .shouldShowRequestPermissionRationale(PermissionGroup.storage);

        // At start [show] is false => Dont show dialogue
        // After denying show will be true => Dont show dialogue
        // If we check dont ask again show will be false => Show dialogue
        if (!isFirstTime && !show) {
          Navigator.of(context).pop();
          PermissionDialog(
            permissionFor: 'storage',
            context: context,
          );
        } else {
          await permissionHandler.requestPermissions([PermissionGroup.storage]);
          status = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.storage);
        }
      }

      if (status == PermissionStatus.disabled ||
          status == PermissionStatus.restricted) {
        Navigator.of(context).pop();
        PermissionDialog(
          permissionFor: 'storage',
          context: context,
        );
      }

      return status == PermissionStatus.granted;
    }

    /// Check photos permission for ios
    if (Platform.isIOS) {
      //
      //
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.photos);

      final PermissionHandler permissionHandler = PermissionHandler();

      if (status == PermissionStatus.unknown) {
        await permissionHandler.requestPermissions([PermissionGroup.photos]);
        status = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.photos);
      }

      if (status == PermissionStatus.denied ||
          status == PermissionStatus.restricted ||
          status == PermissionStatus.disabled) {
        Navigator.of(context).pop();
        PermissionDialog(
          permissionFor: 'photos',
          context: context,
        );
      }

      return status == PermissionStatus.granted ? true : false;
    }

    return false;
  }

  //
  //
}

//////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

/// [_isFirstTimeCameraRequest] function will return true if camera permission is requested for first time otherwise return false
Future<bool> _isFirstTimeCameraRequest() async {
  final String firstTimeCameraRequest = 'firstTimeCameraRequest';
  final Box box = await Hive.openBox(firstTimeCameraRequest);
  if (box.containsKey(firstTimeCameraRequest)) {
    return false;
  } else {
    unawaited(box.put(firstTimeCameraRequest, true));
    return true;
  }
}

/// [_isFirstTimeGalleryRequest] function will return true if gallery permission is
/// requested for first time otherwise return false
Future<bool> _isFirstTimeGalleryRequest() async {
  final String firstTimeGalleryRequest = 'firstTimeGalleryRequest';
  final Box box = await Hive.openBox(firstTimeGalleryRequest);
  if (box.containsKey(firstTimeGalleryRequest)) {
    return false;
  } else {
    unawaited(box.put(firstTimeGalleryRequest, true));
    return true;
  }
}

/// [isFirstTimeLocationRequest] function will return true if location permission is
/// requested for first time otherwise return false
Future<bool> _isFirstTimeLocationRequest() async {
  //
  final String firstTimeLocationRequest = 'firstTimeLocationRequest';
  final Box box = await Hive.openBox(firstTimeLocationRequest);
  if (box.containsKey(firstTimeLocationRequest)) {
    return false;
  } else {
    unawaited(box.put(firstTimeLocationRequest, true));
    return true;
  }
}

import 'package:android_intent/android_intent.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  //
  //
  final String permissionFor;
  final BuildContext context;
  final bool disabled;

  PermissionDialog({
    @required this.context,
    @required this.permissionFor,
    this.disabled = false,
  }) {
    openDialog();
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String message = permissionFor == "camera"
        ? "HireAGuide needs permission to access your device camera to take a photo. Please go to Settings > Privacy > Camera, and enable HireAGuide."
        : "HireAGuide needs permission to access your photo library to select a photo. Please go to Settings > Privacy > Photos, and enable HireAGuide.";

    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: UISize.height(30)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: UISize.width(11)),
                child: Text(
                  "Permission Required",
                  style: StyleText.ralewayBold.copyWith(
                    color: UIColors.darkGray,
                    fontSize: UISize.fontSize(16),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: UISize.width(22)),
                child: Text(
                  message,
                  style: StyleText.ralewayMedium.copyWith(
                      color: UIColors.greyText,
                      fontSize: UISize.fontSize(14),
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: UISize.height(12)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top:
                              BorderSide(width: 1, color: UIColors.lightGray))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: UISize.width(20)),
                            child: Text(
                              "Not Now",
                              style: StyleText.ralewayBold.copyWith(
                                color: UIColors.greyText,
                                fontSize: UISize.fontSize(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: UISize.width(34),
                        width: 1,
                        color: UIColors.lightGray,
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                          onTap: () async {
                            if (this.disabled) {
                              final AndroidIntent intent = AndroidIntent(
                                action:
                                    'android.settings.LOCATION_SOURCE_SETTINGS',
                              );
                              await intent.launch();
                              Navigator.of(context).pop();
                            } else {
                              await PermissionHandler().openAppSettings();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: UISize.width(20)),
                            child: Text(
                              "Open Settings",
                              style: StyleText.ralewayBold.copyWith(
                                color: UIColors.primaryDarkTeal,
                                fontSize: UISize.fontSize(14),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

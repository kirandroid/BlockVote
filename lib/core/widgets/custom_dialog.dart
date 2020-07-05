import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final BuildContext context;
  final String message;
  final String title;
  final String buttonTitle;
  final VoidCallback onPressed;
  final bool customSecondButton;
  final String secondButtonTitle;
  final VoidCallback secondButtonOnPressed;
  final Widget customWidget;

  CustomDialog(
      {@required this.context,
      this.message,
      @required this.title,
      @required this.buttonTitle,
      @required this.onPressed,
      this.customWidget,
      this.customSecondButton,
      this.secondButtonTitle,
      this.secondButtonOnPressed}) {
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
                  title,
                  style: StyleText.ralewayBold.copyWith(
                    color: UIColors.darkGray,
                    fontSize: UISize.fontSize(16),
                  ),
                ),
              ),
              message != null
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UISize.width(22)),
                      child: Text(
                        message,
                        style: StyleText.ralewayMedium.copyWith(
                            color: UIColors.greyText,
                            fontSize: UISize.fontSize(14),
                            height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),

              //For Addition Custom Widgets
              customWidget != null ? customWidget : Container(),
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
                      customSecondButton == null
                          ? Container()
                          : Flexible(
                              flex: 1,
                              child: InkWell(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                                onTap: () {
                                  customSecondButton
                                      ? secondButtonOnPressed()
                                      : Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: UISize.width(20)),
                                  child: Text(
                                    customSecondButton
                                        ? secondButtonTitle
                                        : "Cancel",
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
                          onTap: onPressed,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: UISize.width(20)),
                            child: Text(
                              buttonTitle,
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

import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class RegisterCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: UISize.width(30)),
              child: Text(
                "REGISTRATION COMPLETE",
                textAlign: TextAlign.center,
                style: StyleText.nunitoBold.copyWith(
                    color: UIColors.darkGray, fontSize: UISize.fontSize(30)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: UISize.width(20)),
              child: Text(
                "Please login using your seed phrase or private key!",
                textAlign: TextAlign.center,
                style: StyleText.ralewayMedium.copyWith(
                    color: UIColors.darkGray, fontSize: UISize.fontSize(16)),
              ),
            ),
            RaisedButton(
              color: UIColors.primaryDarkTeal,
              onPressed: () {
                ExtendedNavigator.of(context)
                    .pushReplacementNamed(Routes.loginScreen);
              },
              child: Text(
                "Go To login",
                style: StyleText.ralewayMedium.copyWith(
                    color: UIColors.primaryWhite,
                    fontSize: UISize.fontSize(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

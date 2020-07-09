import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String emptyMsg;
  EmptyScreen({this.emptyMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Search empty Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset("lib/assets/searchEmpty.png"),
          ),

          // Search list is empty text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              emptyMsg.toUpperCase(),
              style: StyleText.ralewayMedium.copyWith(
                  fontSize: UISize.fontSize(16),
                  letterSpacing: 1,
                  color: UIColors.darkGray),
            ),
          ),
        ],
      ),
    );
  }
}

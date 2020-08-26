import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final BorderRadiusGeometry buttonRadius;
  final Color buttonColor;
  final double verticalPadding;
  final bool isLoading;

  const CustomButton(
      {Key key,
      this.title,
      this.onPressed,
      this.buttonRadius,
      this.buttonColor,
      this.verticalPadding,
      this.isLoading = false})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.buttonColor != null
              ? widget.buttonColor
              : UIColors.primaryDarkTeal,
          borderRadius: widget.buttonRadius != null
              ? widget.buttonRadius
              : BorderRadius.circular(10)),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: widget.buttonRadius,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? UISize.width(20)),
            alignment: Alignment.center,
            child: widget.isLoading
                ? CircularProgressIndicator()
                : Text(
                    widget.title,
                    style: StyleText.ralewaySemiBold.copyWith(
                        fontSize: UISize.fontSize(16),
                        letterSpacing: 2,
                        color: UIColors.primaryWhite),
                  ),
          ),
        ),
      ),
    );
  }
}

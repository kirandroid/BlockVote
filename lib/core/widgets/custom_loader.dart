import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color colors;

  const CustomLoader({
    Key key,
    this.size,
    this.strokeWidth,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: this.size ?? 33.0,
          height: this.size ?? 33.0,
          child: CircularProgressIndicator(
            strokeWidth: this.strokeWidth ?? 1.5,
            valueColor:
                AlwaysStoppedAnimation<Color>(this.colors ?? Colors.blue),
          ),
        ),
      ),
    );
  }
}

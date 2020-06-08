import 'package:flutter_screenutil/flutter_screenutil.dart';

class UISize {
  UISize._();
  static double height(double height) =>
      ScreenUtil().setHeight(height) as double;
  static double width(double width) => ScreenUtil().setWidth(width) as double;
  static double fontSize(double size) => ScreenUtil().setSp(size) as double;
}

import 'package:flutter/material.dart';

class MyResponsive {
  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext context) {
    return mediaQueryData(context).size;
  }

  double width(BuildContext context) {
    return size(context).width;
  }

  double height(BuildContext context) {
    return size(context).height;
  }
}

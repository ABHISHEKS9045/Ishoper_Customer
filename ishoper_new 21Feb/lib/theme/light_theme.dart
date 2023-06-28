import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/mycartpage.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  // primaryColor: Color(0xFF1B7FED),
  primaryColor: color.colortheme,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: Color(0xFF9E9E9E),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fosdem/widgets/fosdem_button.dart';

const fosdemAppBarShadowOpacity = Color.fromRGBO(0, 0, 0, 0.4);
const fosdemWhite = Colors.white;
const fosdemBlue = Color.fromRGBO(97, 169, 210, 1);
const fosdemLightBlue = Color.fromRGBO(34, 221, 242, 1);
const fosdemGreen = Color.fromRGBO(168, 228, 158, 1);
const fosdemYellow = Color.fromRGBO(254, 234, 98, 1);
const fosdemLightGrey = Color.fromARGB(255, 217, 217, 217);
const fosdemGrey = Color.fromARGB(255, 159, 159, 159);

const bottomNavigationBarSelectedItemColor = fosdemBlue;
const bottomNavigationBarUnselectedItemColor = fosdemLightGrey;

var fosdemElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: fosdemBlue,
  shape: RoundedRectangleBorder(
    borderRadius: fosdemBorderRadius,
  ),
);

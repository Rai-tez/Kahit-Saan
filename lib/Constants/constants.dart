import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
* Do not leave anything blank, please put an acceptable default value
* when changing values
*
* Yes I am aware that there are [2] non constant variables in a constants file
*
* xD
* */

/// colors and overall theme

const kyellow = Color(0xFFF2BD57);
const kbrown = Color(0xFF4C3E23);
const kbeige = Color(0xFFF9E8CC);
const kgrey = Colors.black12;
const kblack = Color(0xFF0A0A0A);
const kwhite = Colors.white;
const kdgrey = Color(0xFF696969);
const kred = Color(0xFFa11b29);

/// Splash Screen
const ksplashScreen = TextStyle(
  fontFamily: 'Lobster',
  fontSize: 25,
  color: kbrown,
);

/// Circle Color
const Color circle_area_color = Color.fromARGB(20, 0, 0, 255);
const Color circle_edge_color = Color(0xFFF2BD57);
const int circle_stroke_width = 3;

/// Use Current Location Button
const kcurrLocButton = TextStyle(
  fontSize: 12,
  color: kyellow,
);

/// Type of Place Button
const ktypeButton = TextStyle(
  color: kbrown,
  fontFamily: 'Playfair',
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

/// Main Function buttons
const kfunctionButton = TextStyle(
  fontSize: 14,
  fontFamily: 'Roboto',
);

/// Polylines
const Color line_color = Colors.redAccent;
const int line_width = 3;
PatternItem line_pattern = PatternItem.dash(10.0);

/// Restaurant Markers

BitmapDescriptor resto_color_marker =
    BitmapDescriptor.defaultMarkerWithHue(35.0);

/// Sliding Up Panel

const BorderRadius topLeftRight_border = BorderRadius.only(
    topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0));

///Search Radius
const ksearchRadius = TextStyle(
  fontFamily: 'BebasNeue',
  fontSize: 18,
  color: kbrown,
  letterSpacing: 1,
);

///Pop-up and Listahan Please
const ktitle = TextStyle(
  color: kbrown,
  fontSize: 30.0,
  fontFamily: 'Lobster',
  letterSpacing: 1.5,
);

const kplaceName = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 18.0,
  fontFamily: 'Roboto',
);

const kdescription = TextStyle(
  fontSize: 15.0,
  color: kdgrey,
  fontFamily: 'Roboto',
);

const knoResult = TextStyle(
  fontSize: 18,
  fontFamily: 'Playfair',
);

const kpiliButtons =
    TextStyle(fontSize: 16, color: kbrown, fontFamily: 'Roboto');

/// Bottom App Bar
const kcurrLoc = TextStyle(
  fontSize: 13,
  color: kbrown,
  fontFamily: 'BebasNeue',
  letterSpacing: 1,
);

/// Drawer
const kdrawerOptions = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 15,
  color: kbrown,
);
